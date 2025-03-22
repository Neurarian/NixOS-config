local M = {}
M.for_cat = {
    spec_field = "for_cat",
    set_lazy = false,
    modify = function(plugin)
        if type(plugin.for_cat) == "table" and plugin.for_cat.cat ~= nil then
            if vim.g[ [[nixCats-special-rtp-entry-nixCats]] ] ~= nil then
                plugin.enabled = nixCats(plugin.for_cat.cat) or false
            else
                plugin.enabled = plugin.for_cat.default
            end
        else
            plugin.enabled = nixCats(plugin.for_cat) or false
        end
        return plugin
    end,
}

return M

require("cinnamon").setup {
    -- Enable all provided keymaps
    keymaps = {
        basic = true,
        extra = true,
    },
    options = {
        delay = 3,
        max_delta = {
            line = false,
            column = false,
            time = 200,
        },
    },
}

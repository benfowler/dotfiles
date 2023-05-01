local present, fidget = pcall(require, "fidget")

if not present then
    return
end

fidget.setup {
    text = {
        spinner = "dots",
        done = " 󰄬",
        completed = "Done",
    },
    timer = {
        fidget_decay = 3600,
        task_decay = 1800,
    },
    window = {
        blend = 5,
    },
}


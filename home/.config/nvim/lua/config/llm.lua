-- https://github.com/nraw/dotfiles/blob/7c0f433ba5b64f44236c522681c1b7f616fb0c5c/nvim/.config/nvim/lua/prompt_library.lua

local codellama = require("model.providers.codellama")
local openai = require("model.providers.openai")
local openai_compat = {
    url = "http://192.168.99.90:8080/v1/",
}

local mode = require("model").mode
local prompt_utils = require('model.util.prompts')

local prompts = {}

prompts["ask"] = {
    provider = openai,
    options = openai_compat,
    params = {
        temperature = 0.7,
        max_tokens = 256,
    },
    builder = function (input)
        return function(build)
            vim.ui.input(
                { prompt = "Question: " },
                function(question)
                    build({
                        messages = {
                            {
                                role = "system",
                                content =
                                    "You are helpful assistant. " ..
                                    "If a question does not make any sense, or is not factually coherent, " ..
                                    "explain why instead of answering something not correct. " ..
                                    "If you don't know the answer to a question, " ..
                                    "please don't share false information. " ..
                                    "Answer the question using the context below. "
                            },
                            {
                                role = "user",
                                content =
                                    "Context: \n" .. input .. "\n" ..
                                    "Question: " .. question,
                            }
                        }
                    })
                end)
            end
    end,
}

prompts["commit"] = {
    provider = openai,
    options = openai_compat,
    mode = mode.INSERT,
    builder = function()
        local git_diff = vim.fn.system {'git', 'diff', '--staged'}
        return {
            messages = {
                {
                    role = "system",
                    content =
                        "Write a short commit message according to the " ..
                        "Conventional Commits specification. " ..
                        "Try to stay below 80 characters total. " ..
                        "Git diff: \n```\n" .. git_diff .. "\n```"
                }
            }
        }
    end,
}

prompts["code-assist"] = {
    provider = openai,
    options = openai_compat,
    builder = function(input)
        return {
            messages = {
                {
                    role = "system",
                    content =
                        "You are a highly competent programmer. " ..
                        "Continue only with code. " ..
                        "Do not write tests, examples, or output of code " ..
                        "unless explicitly asked for. " ..
                        "Include only valid code in your response.",
                },
                {
                    role = "user",
                    content = input,
                }
            }
        }
    end,
}

require("model").setup({
    default_prompt = prompts["ask"],
    prompts = prompts
})

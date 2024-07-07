-- ~/Documents/GitHub/LDSLibrary.nvim/lua/myplugin/commands/fetch_html.lua
local curl = require('plenary.curl')
table.unpack = table.unpack or unpack

local M = {}
-- Function to remove HTML tags

-- Function to fetch content and insert into buffer
---@param language string
---@param uri string
---@param first? string|integer
---@param last? string|integer
---@param individual? table
---@param opts? table
function M.scripturequery(language, uri, first, last, individual,opts)
        -- Ensure inputs are strings and convert them to numbers if they are not nil
        first = first and tonumber(first)
        last = last and tonumber(last)

        -- If only first is provided, treat it as both first and last
        if first and not last then
            last = first
        end

        -- Ensure individual is a table
        individual = individual or {}
        opts = opts or {}

        -- Convert individual entries to numbers
        local individual_numbers = {}
        for _, num_str in ipairs(individual) do
            table.insert(individual_numbers, tonumber(num_str))
        end

    local url = string.format("https://www.churchofjesuschrist.org/study/api/v3/language-pages/type/content?lang=%s&uri=%s", language, uri)
    
    local function remove_html_tags(str)
        return str:gsub("<.->", "")
    end
    -- Function to extract paragraphs
    local function extract_paragraphs(html)
        local paragraphs = {}
        for p_tag in html:gmatch('<p class=\\"verse\\".-</p>') do
            local verse_number = p_tag:match('<span class=\\"verse%-number\\">(.-)</span>') or ""
            local verse_text = p_tag:gsub('<span class=\\"verse%-number\\">.-</span>', ""):match('">(.-)</p>') or ""
            -- Remove additional HTML tags from verse text
            verse_text = remove_html_tags(verse_text)
            paragraphs[verse_number] = verse_text
        end
        return paragraphs
    end
    -- Make the GET request
    local result = curl.get(url)

    -- Check if the request was successful
    if result.status == 200 then
        local body = result.body

        -- Extract paragraphs from HTML content
        local paragraphs = extract_paragraphs(body)

        -- Collect the verses based on input range and individual verses
        local verses_to_insert = {}
        for verse_number, verse_text in pairs(paragraphs) do
            local num_verse_number = tonumber(verse_number)
            local in_range = num_verse_number and first and last and num_verse_number >= first and num_verse_number <= last
            local in_individual = vim.tbl_contains(individual_numbers, num_verse_number)
            if in_range or in_individual then
                table.insert(verses_to_insert, {num_verse_number, verse_text})
            end
        end

        -- Sort the verses to insert by verse number
        table.sort(verses_to_insert, function(a, b) return a[1] < b[1] end)


        -- Extract just the text for insertion
        local verses_text = {}
        for _, verse in ipairs(verses_to_insert) do
            table.insert(verses_text, tostring(verse[1]) .. " " .. verse[2])
        end

        -- Insert the verses at the cursor position
        if #verses_text > 0 then
            local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
            vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, verses_text)
        else
            print("No matching verses found in the HTML content.")
        end
    else
        print("Failed to fetch data from the URL. Status code:", result.status)
    end
end

return M

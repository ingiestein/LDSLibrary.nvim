local M ={}
-- Function to format a string as a Markdown header
function M.format_as_header(content, level)
    local header_prefix = string.rep("#", level) .. " "
    return header_prefix .. content
  end
  
  -- Function to format a string as a Markdown link
  function M.format_as_link(link_text, link_url)
    return string.format("[%s](%s)", link_text, link_url)
  end
  
  -- Function to format a string as bold text
  function M.format_as_bold(content)
    return string.format("**%s**", content)
  end
  
  -- Function to format a string as italic text
  function M.format_as_italic(content)
    return string.format("*%s*", content)
  end
  
  -- Function to format a string as inline code
  function M.format_as_code(content)
    return string.format("`%s`", content)
  end

  function M.format_obsidian_reference(referenceobject,verses_to_insert)
    local header = M.format_title_line(referenceobject,verses_to_insert)
    local link = M.make_link_line(referenceobject)
    local gap = ">"
    local md_verses = M.make_verses_pars(verses_to_insert)
    local output = {}
    table.insert(output,header)
    table.insert(output,link)
    table.insert(output,gap)
    for _,verse in ipairs(md_verses)do
        table.insert(output,verse)
    end
    return output
  end

  function M.make_link_line(reference_object)
    -- > [churchofjesuschrist.org](https://www.churchofjesuschrist.org/study/scriptures/bofm/alma/32?lang=eng&id=p17-p18#p17)
    return string.format("> [churchofjesuschrist.org](https://www.churchofjesuschrist.org/study%s)",reference_object.cannonical_url)
  end

  function M.format_title_line(referenceobject,verses_to_insert)
    local number_part = M.format_number_list(M.get_verse_nums(verses_to_insert))
    return string.format("> [!Mormon] [[%s|%s:%s]]",
        referenceobject.in_language_title,
        referenceobject.in_language_title,
        number_part
)
  end

  function M.get_verse_nums(verses_to_insert)
    local keys = {}
	for key in pairs(verses_to_insert) do
		table.insert(keys, key)
	end
	table.sort(keys)
    return keys
end

function M.make_verses_pars(verses_to_insert)
    local keys = M.get_verse_nums(verses_to_insert)
	-- Step 2: Sort the list of keys
	local text = {}
	-- Step 3: Iterate over the sorted list to access the values
	for _, key in ipairs(keys) do
		-- print("Key:", key, "Value:", verses_to_insert[key])
		table.insert(text, "> " .. M.format_as_bold(tostring(key)) .. " " .. verses_to_insert[key])
	end
    return text
end

  -- TODO: Ensure this function is right.
  function M.format_number_list(numbers)
    -- {1,2,3,5,7}
    if #numbers == 0 then return "" end
    table.sort(numbers) -- Ensure the numbers are sorted
    local result = {}
    local range_start = numbers[1] --1
    local range_end = numbers[1]--1
  
    for i = 2, #numbers do
      if numbers[i] == range_end + 1 then -- if next entry is 1 more than previous
        -- Continue the range
        range_end = numbers[i] -- range end is current enty
      else
        -- End the current range and start a new one
        if range_start == range_end then
          table.insert(result, tostring(range_start))
        else
          table.insert(result, range_start .. "-" .. range_end)
        end
        range_start = numbers[i]
        range_end = numbers[i]
      end
    end
  
    -- Add the last range
    if range_start == range_end then
      table.insert(result, tostring(range_start))
    else
      table.insert(result, range_start .. "-" .. range_end)
    end
  
    return table.concat(result, ", ")
  end

return M
  
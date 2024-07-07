local levenshtein = require("LDSLibrary.utils.Levenshtein")


local M = {}

-- List of expected book names
M.books = {
    "Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua",
    "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings",
    "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job",
    "Psalms", "Proverbs", "Ecclesiastes", "Solomon's Song", "Isaiah", "Jeremiah",
    "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah",
    "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah",
    "Malachi", "Matthew", "Mark", "Luke", "John", "Acts", "Romans",
    "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians",
    "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy",
    "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John",
    "2 John", "3 John", "Jude", "Revelation", "1 Nephi", "2 Nephi", "Jacob",
    "Enos", "Jarom", "Omni", "Words of Mormon", "Mosiah", "Alma", "Helaman",
    "3 Nephi", "4 Nephi", "Mormon", "Ether", "Moroni", "Doctrine and Covenants",
    "Moses", "Abraham", "Joseph Smith--Matthew", "Joseph Smith--History",
    "Articles of Faith"
}

-- Function to find the best match for a given input
function M.find_best_match(input)
    local best_match = nil
    local lowest_score = math.huge  -- Use math.huge to initialize to + infinity

    for _, book in ipairs(M.books) do
        local score = levenshtein(book,input)
        -- print(score, book, input)
        if score < lowest_score then
            lowest_score = score
            best_match = book
        end
    end


    return best_match
end

return M

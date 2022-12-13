-- Set the path to search for handling.meta files
local searchPath = "C:/Users/Administrator/Desktop/test"
cycles = 1

-- Recursively search for handling.meta files
local function searchForFiles(path)
  -- Create a list to store the found files
  local files = {}

  -- Get a list of all files and directories in the given path
  for file in io.popen('dir "'..path..'" /b /s'):lines() do
    -- Check if the file is a handling.meta file
    if file:match("handling.meta$") then
      -- Add the file to the list of found files
      table.insert(files, file)
    end
  end

  -- Return the list of found files
  return files
end

-- Read the contents of a file
local function readFile(file)
  -- Check if the file exists
  if not io.open(file, "r") then
    return nil
  end

  -- Open the file for reading
  local f = io.open(file, "r")

  -- Read the contents of the file
  local contents = f:read("*all")

  -- Close the file
  f:close()

  -- Return the contents of the file
  return contents
end

-- Write the contents to a file
local function writeFile(file, contents)
  if not io.open(file, "r") then
    return nil
  end
  -- Open the file for writing
  local f = assert(io.open(file, "w"))
  -- Write the contents to the file
  f:write(contents)
  -- Close the file
  f:close()
end

-- Find all handling.meta files
local files = searchForFiles(searchPath)

-- Iterate over the list of files
for _, file in pairs(files) do

  -- Read the contents of the file
  local contents = readFile(file)

  -- Replace the line containing the the first word with the new value
  contents = (contents or ""):gsub("<fInitialDragCoeff.-/>", "<fInitialDragCoeff value=\"10.0\" />")
  contents = (contents or ""):gsub("<fHandBrakeForce.-/>", "<fHandBrakeForce value=\"1.6\" />")
  contents = (contents or ""):gsub("<fTractionCurveLateral.-/>", "<fTractionCurveLateral value=\"19.5\" />")
  contents = (contents or ""):gsub("<fTractionLossMult.-/>", "<fTractionLossMult value=\"0.8\" />")

  -- fHandBrakeForce:  1.5
  -- fTractionCurveLateral:  19.5
  -- fTractionLossMult:  0.8

  -- Write the updated contents back to the file
  cycles = cycles + 1
  print("Cars Done: " .. cycles)
  writeFile(file, contents)
end

print("----------------Code Successful----------------")

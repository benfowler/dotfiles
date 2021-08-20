local our_modules = {
   "options",
   "mappings",
}

for i = 1, #our_modules, 1 do
   if not pcall(require, our_modules[i]) then
      error("Error loading " .. our_modules[i] .. "\n")
   end
end

require("mappings").misc()

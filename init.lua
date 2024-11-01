-- gravity_setting.lua

-- Register the chat command to open the gravity setting formspec
minetest.register_chatcommand("set_gravity", {
    description = "Open gravity setting scrollbar",
    func = function(name)
        -- Show the formspec when the command is executed
        local formspec = "size[8,3]label[0,0;Set Gravity (0.1 - 1.0)]" ..
                         "scrollbar[0,1;8;0.1,1;0.1;horizontal]" ..
                         "label[0,2;Current Value: 0.1]" ..
                         "button[6,2;2,1;save;Save]"
        minetest.show_formspec(name, "gravity_setting:gravity", formspec)
        return true, "Gravity settings opened."
    end,
})

-- Function to update the formspec with the current gravity setting
local function update_gravity_formspec(player_name, current_value)
    local formspec = "size[8,3]" ..
                     "label[0,0;Set Gravity (0.1 - 1.0)]" ..
                     "scrollbar[0,1;8;0.1,1;" .. current_value .. ";horizontal]" ..  -- Horizontal scrollbar for gravity value
                     "label[0,2;Current Value: " .. current_value .. "]" ..  -- Display current value
                     "button[6,2;2,1;save;Save]"  -- Save button

    minetest.show_formspec(player_name, "gravity_setting:gravity", formspec)  -- Show the formspec to the player
end

-- Register a callback to handle player input from the formspec
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "gravity_setting:gravity" then
        local player_name = player:get_player_name()

        -- If the scrollbar is adjusted, update the label dynamically
        if fields.scrollbar then
            local selected_gravity = tonumber(fields.scrollbar)  -- Get the value from the scrollbar
            if selected_gravity then
                -- Refresh the formspec to show the new value
                update_gravity_formspec(player_name, string.format("%.1f", selected_gravity))  -- Show the new value
            end
        end
        
        -- If the save button is clicked
        if fields.save then
            local new_gravity = tonumber(fields.scrollbar)  -- Get the value from the scrollbar
            if new_gravity then
                minetest.setting_set("gravity", new_gravity)  -- Save the new gravity setting
                minetest.chat_send_player(player_name, "Gravity saved: " .. new_gravity)  -- Notify the player
            end
        end
    end
end)

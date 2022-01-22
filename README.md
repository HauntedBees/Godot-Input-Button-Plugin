# Godot-Input-Button-Plugin
Buttons with icons indicating the relevant key or gamepad button.

# InputDisplay
This node will display a specified user input, such as a keypress, a gamepad button (XBox, Sony, and Nintendo styles), or a direction on an analog stick or d-pad. Unless you really want to show a very specific symbol devoid of context or meaning, the only variables you'll likely care about are **sheet**, **overlay**, **font**, **pressed_tint** , and maybe **compress_dpad_and_analog_sticks**, and then just use the **ActionInput** node (described below) instead.

## Export Variables

### sheet
A *SpriteFrames* `tres` file containing a **default** animation with 16 frames to represent the following, in order:
 0. face button
 1. left shoulder button
 2. right shoulder button
 3. keyboard key
 4. a start/back button and longer keyboard keys like "Tab"
 5. a representation of a gamepad's face button layout, with the top button highlighted
 6. a directional pad
 7. a directional pad pressed upwards
 8. an analog stick
 9. an analog stick being pressed down (like L3 or R3 on modern gamepads)
 10. *blank*
 11. *blank*
 12. an analog stick tilted left
 13. an analog stick tilted up
 14. an analog stick tilted right
 15. an analog stick tilted down

 ### overlay
 A *SpriteFrames* `tres` file containing a **default** animation with 5 frames to represent the following, in order:
  0. a directional arrow pointing up (to represent keyboard arrow keys)
  1. a DualShock "square" symbol
  2. a DualShock "circle" symbol
  3. a DualShock "triangle" symbol
  4. a DualShock "cross" symbol

### font
A *DynamicFont* `tres` file containing a font to be used to display button/key symbols on the sprites.

### gamepad_type
This will determine how gamepad buttons are represented. Each one shows the four face buttons (clockwise from the top), the left and right bumpers, the left and right triggers, and the left and right analog sticks being pressed down as:
 - "xb": Y B A X LB RB LT RT L3 R3
 - "ps": Triangle Circle Cross Square L1 R1 L2 R2 L3 R3
 - "ds": X A B Y L R ZL ZR L3 R3
 - "joycon": \* \* \* \* SL SR ZL ZR L3 R3
    - the face buttons are represented with a symbol indicating the _position_ of the face button instead of the letter/symbol on it

### key_code
The [KeyList](https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-keylist) or [JoyStickList](https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-keylist) of the input to display.

### pressed
Whether or not to tint the button with the **pressed_tint** value.

### pressed_tint
Tint the button to indicate it is being pressed down when the **pressed** value is `true`.

### compress_dpad_and_analog_sticks
When `true`, the standard directional pad or analog stick will be shown when the **key_code** value refers to the directional pad or analog stick being pressed in a certain direction. When `false`, the specified direction is shown.

### axis
The direction of the axis if one is specified. `0` if the specified **key_code** is not an axis, `1` and `-1` for positive and negative, respectively.

# ActionDisplay
A node that inherits from **InputDisplay**. This Node will compare its **action** property against the [InputMap](https://docs.godotengine.org/en/stable/classes/class_inputmap.html) (initially specified in the Project Settings) and will update dynamically based on the keys/buttons assigned to the action, what input methods are connected, and whether or not they're pressed. All **ActionDisplay** nodes belong to the `action_display` group, and when assigned to a valid action they will also belong to the `action_display_[action]` group (ex. `action_display_ui_accept`, `action_display_ui_right`).

## Export Variables

### action
The name of an **action**, as specified in **Project Settings > Input Map**. This Node will show which button/key should be pressed to trigger this action. If multiple events of the same type (such as multiple **InputEventKey** mappings), the *first* one will be used. For example, the default **ui_accept** action accepts both the Enter key, Space key, and *Device 0, Button 0 (DualShock Cross, Xbox A, Nintendo B)* as its events. When no gamepad is plugged in, this Node will depict an Enter key - not the Space key. If a gamepad is plugged in, this Node will depict a button with a cross symbol, A, or B in it, depending on the type of gamepad.

### gamepad_slot
The device id to compare this action against. In the **Input Map**, when you see things like **Device *X*, Axis 0** or **Device *X*, Button 3**, this is the *X*.

### pressable
If `true`, this Node will display a "pressed" graphic (based on the **pressed_tint**) when the **action** key/button/axis is pressed. If `false`, this Node's graphic will not change based on player input.

### prefer_axis
If an **action** has both an **InputEventJoypadButton** *and* **InputEventJoypadMotion** mapped to it (such as **ui_left** being mapped to both the left directional pad and left on the left joystick), set this to `true` to show the **InputEventJoypadMotion**'s graphic (the left analog stick) or `false` to show the **InputEventJoypadButton**'s graphic (the left directional pad). If the action only has one or the other, this variable is ignored.

## Functions You Might Call

### set_action(a:String)
If you wish to update the action of this Node in code, you can just call `$ActionDisplay.action = "ui_accept"` and this setter function will be called, but if you need to, you can also call this function using the Node's group (`get_tree().call_group("action_display", "set_action", "ui_accept")`). The main reason you might want to use this technique would be if you're reassigning the controls for an action, then you can trigger a refresh of all relevant Nodes with `get_tree().call_group("action_display_your_action_name", "set_action", "your_action_name")`.


# Example Project

## Example.tscn
Just shows off a the nodes a bit. Nothing really special here. Main thing of note is that when you connect/disconnect gamepads, you can see the **ActionInput** Nodes updating automatically.

## Button Remapping Example.tscn
A scene with a rectangle you can move and rotate, with the ability to remap the controls. When **Manually configure Movement Directions** is unchecked (as it is by default), the remap will try automatically updating all four directions based on your input. If you press something on your gamepad's directional pad, it'll automatically map up to directional pad up, down to directional pad down, left to directional pad left, and right to directional pad right. This will also work with the left and right analog sticks on a gamepad. When this is checked, you can manually specify unique inputs for each of the four directions.
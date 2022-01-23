# Godot v3.4 Input Button Plugin
Buttons with icons indicating the relevant key or gamepad button. Includes three Nodes:
 - **InputDisplay**: For displaying a specific button or key.
 - **ActionDisplay**: For displaying a specific **InputMap action** and updating based on the current control method (keyboard/gamepad) and whether or not the action is being pressed.
 - **ActionButton**: A button with an **ActionDisplay** icon, that can be triggered both on click/touch events like a regular button or by pressing the specified **InputMap action**.

# Installation
Copy `addons/input_button` into your project (final path should be `res://addons/input_button`). In the Godot Editor, go to **Project Settings > Plugins** and enable the **Input Button Plugin**. You can now add **InputDisplay** and **ActionDisplay** nodes to your project.

# InputDisplay
This node will display a specified user input, such as a keypress, a gamepad button (XBox, Sony, and Nintendo styles), or a direction on an analog stick or d-pad. Unless you really want to show a very specific symbol devoid of context or meaning, you should just use the **ActionInput** node (described below) instead.

## Inspector Properties

### Sheet
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

 ### Overlay
 A *SpriteFrames* `tres` file containing a **default** animation with 5 frames to represent the following, in order:
  0. a directional arrow pointing up (to represent keyboard arrow keys)
  1. a DualShock "square" symbol
  2. a DualShock "circle" symbol
  3. a DualShock "triangle" symbol
  4. a DualShock "cross" symbol

### Font
A *DynamicFont* `tres` file containing a font to be used to display button/key symbols on the sprites.

### Gamepad Type
This will determine how gamepad buttons are represented. Each one shows the four face buttons (clockwise from the top), the left and right bumpers, the left and right triggers, and the left and right analog sticks being pressed down as:
 - "xb": Y B A X LB RB LT RT L3 R3
 - "ps": Triangle Circle Cross Square L1 R1 L2 R2 L3 R3
 - "ds": X A B Y L R ZL ZR L3 R3
 - "joycon": \* \* \* \* SL SR ZL ZR L3 R3
    - the face buttons are represented with a symbol indicating the _position_ of the face button instead of the letter/symbol on it

### Key Code
The [KeyList](https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-keylist) or [JoyStickList](https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-joysticklist) of the input to display.

### Pressed
Whether or not to tint the button with the **Pressed Tint** value.

### Pressed Tint
Tint the button to indicate it is being pressed down when the **Pressed** value is `true`.

### Compress Dpad And Analog Sticks
When `true`, the standard directional pad or analog stick will be shown when the **Key Code** value refers to the directional pad or analog stick being pressed in a certain direction. When `false`, the specified direction is shown.

### Axis
The direction of the axis if one is specified. `0` if the specified **Key Code** is not an axis, `1` and `-1` for positive and negative, respectively.

### Font Color
The font color of the symbol text.

### xxxx Offset
How much the text or symbol on a given display type should be offset from the center of the Node. If you're using a custom **Sheet** value, the default offsets may not match your sprite frames, so tweak these to your liking.

### Long Key Text Scale
The "long key" type (sprite index `4` in **Sheet**) is used for keys/buttons that might have longer names, like "Tab", "Start" or "Enter." The display text will be scaled down to fit based on this value. 

# ActionDisplay
A node that inherits from **InputDisplay**. This Node will compare its **action** property against the [InputMap](https://docs.godotengine.org/en/stable/classes/class_inputmap.html) (initially specified in the Project Settings) and will update dynamically based on the keys/buttons assigned to the action, what input methods are connected, and whether or not they're pressed. All **ActionDisplay** nodes belong to the `action_display` group, and when assigned to a valid action they will also belong to the `action_display_[action]` group (ex. `action_display_ui_accept`, `action_display_ui_right`).

## Inspector Properties

All of the above, but **Gamepad Type**, **Key Code**, **Pressed**, and **Axis** will be overwritten as needed based on the **ActionDisplay** Node's **Action** value and should not be manually set. Variables unique to the **ActionDisplay** are:

### Action
The name of an **action**, as specified in **Project Settings > Input Map**. This Node will show which button/key should be pressed to trigger this action. If multiple events of the same type (such as multiple **InputEventKey** mappings), the *first* one will be used. For example, the default **ui_accept** action accepts both the Enter key, Space key, and *Device 0, Button 0 (DualShock Cross, Xbox A, Nintendo B)* as its events. When no gamepad is plugged in, this Node will depict an Enter key - not the Space key. If a gamepad is plugged in, this Node will depict a button with a cross symbol, A, or B in it, depending on the type of gamepad.

### Gamepad Slot
The device id to compare this action against. In the **Input Map**, when you see things like **Device *X*, Axis 0** or **Device *X*, Button 3**, this is the *X*.

### Pressable
If `true`, this Node will display a "pressed" graphic (based on the **Pressed Tint**) when the **Action** key/button/axis is pressed. If `false`, this Node's graphic will not change based on player input.

### Prefer Axis
If an **action** has both an **InputEventJoypadButton** *and* **InputEventJoypadMotion** mapped to it (such as **ui_left** being mapped to both the left directional pad and left on the left joystick), set this to `true` to show the **InputEventJoypadMotion**'s graphic (the left analog stick) or `false` to show the **InputEventJoypadButton**'s graphic (the left directional pad). If the action only has one or the other, this variable is ignored.

## Functions You Might Call

### set_action(a:String)
If you wish to update the action of this Node in code, you can just call `$ActionDisplay.action = "ui_accept"` and this setter function will be called, but if you need to, you can also call this function using the Node's group (`get_tree().call_group("action_display", "set_action", "ui_accept")`). The main reason you might want to use this technique would be if you're reassigning the controls for an action, then you can trigger a refresh of all relevant Nodes with `get_tree().call_group("action_display_your_action_name", "set_action", "your_action_name")`.

## Godot Editor Note
While the **InputDisplay** will always update automatically in the Godot Editor, the **ActionDisplay** will not update based on the **action** value due to the behavior of the **Input Map** settings in Godot. To my knowledge, there is no fix for this in Godot 3.4. If you wish to see how the Node looks in the Editor, you can set the **gamepad_type**, **key_code** and **axis** manually in the **Inspector panel** to preview the styles. However, they will be immediately overwritten based on the **action** value at runtime. 

# ActionButton
A **Button** with a dynamically updating **ActionDisplay** as its icon. **button_down**, **button_up**, and **pressed** signals are emitted as they would be for a normal button, but will also be emitted when the user presses/releases the relevant action.

## Inspector Properties

### Custom Display Action
By default, this uses an **ActionDisplay** with its default styles applied as its icon. If you want to change things (like the **Sheet** and **Font**), just make a new scene with just your customized **ActionDisplay** in it, save that scene, and select it here.

## Action
The **InputMap action** you want to tie to this button. Passes the value down to the **Action** variable of the **ActionDisplay**.

## Icon Size
If you're using a **Custom Display Action** and your icons aren't 64x64, resize them here.

# Example Project

## Example.tscn
Just shows off a the nodes a bit. Nothing really special here. Main thing of note is that when you connect/disconnect gamepads, you can see the **ActionInput** Nodes updating automatically.

## Button Remapping Example.tscn
A scene with a rectangle you can move and rotate, with the ability to remap the controls. When **Manually configure Movement Directions** is unchecked (as it is by default), the remap will try automatically updating all four directions based on your input. If you press something on your gamepad's directional pad, it'll automatically map up to directional pad up, down to directional pad down, left to directional pad left, and right to directional pad right. This will also work with the left and right analog sticks on a gamepad. When this is checked, you can manually specify unique inputs for each of the four directions.

## ActionButtonTest.tscn
Showing off the **ActionButton** Node. Two buttons that can be activated by clicking or pressing the relevant key/button.

# License

Copyleft, but, like, whatever. If you've read this far and you're some new indie gamedev or something who really thinks this code will help you but for some reason you're very determined not to open source your game for whatever reason, I think that's weird but realistically don't care. If your game or project makes less than $1,000 or something, you can interpret this as me granting you a license to use this code in your proprietary game (with credit). If your project makes more than that, either release its source under a license compatible with the AGPLv3, take my code out of your project, or send me ten bucks.
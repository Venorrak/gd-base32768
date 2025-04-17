# Base32768
Base32768 is a binary encoding optimised for UTF-16-encoded text. 

This Godot plugin is an implementation of an already existing javascript plugin in gdscript. 
Link to the original repository : https://github.com/qntm/base32768

## Usage

```gdscript
var toTranslate = "testma"
var base = Base32768.new()

toTranslate.to_utf8_buffer()
# [116, 101, 115, 116, 109, 97]

var encoded = base.encode(toTranslate.to_utf8_buffer())
# "悒茽㇌Ɵ"

var decoded = base.decode(encoded)
# [116, 101, 115, 116, 109, 97, 0, 0]

decoded.get_string_from_utf8()
# "tesma"
```

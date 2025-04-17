class_name base_32768 extends Node
## Helper class for encoding and decoding base32768 data.
##
## Base32768 is a binary encoding optimised for UTF-16-encoded text.
## [br][br]
## This Godot plugin is an implementation of an already existing javascript plugin in gdscript.
## [br]
## Link to the original repository : [url]https://github.com/qntm/base32768[/url]
## [br]
## [codeblock]var toTranslate = "testma"
##
## toTranslate.to_utf8_buffer()
## # [116, 101, 115, 116, 109, 97]
##
## var encoded = Base32768.encode(toTranslate.to_utf8_buffer())
## # "悒茽㇌Ɵ"
##
## var decoded = Base32768.decode(encoded)
## # [116, 101, 115, 116, 109, 97, 0, 0]
##
## decoded.get_string_from_utf8()
## # "tesma"
##[/codeblock]



const BITS_PER_CHAR = 15
const BITS_PER_BYTE = 8

## don't touch
var pair_strings : PackedStringArray = [
	"ҠҿԀԟڀڿݠޟ߀ߟကဟႠႿᄀᅟᆀᆟᇠሿበቿዠዿጠጿᎠᏟᐠᙟᚠᛟកសᠠᡟᣀᣟᦀᦟ᧠᧿ᨠᨿᯀᯟᰀᰟᴀᴟ⇠⇿⋀⋟⍀⏟␀␟─❟➀➿⠀⥿⦠⦿⨠⩟⪀⪿⫠⭟ⰀⰟⲀⳟⴀⴟⵀⵟ⺠⻟㇀㇟㐀䶟䷀龿ꀀꑿ꒠꒿ꔀꗿꙀꙟꚠꛟ꜀ꝟꞀꞟꡀꡟ",
	"ƀƟɀʟ"
]

## don't touch
var lookup_e = {}

## don't touch
var lookup_d = {}

func _init():
	for r in pair_strings.size():
		var pair_string : Array[String] = get_array_from_string(pair_strings[r])
		var encode_repertoire : Array = []
		for i in pair_string.size() / 2:
			var first : int = pair_string.pop_front().unicode_at(0)
			var last : int = pair_string.pop_front().unicode_at(0)
			for code_point in range(first, last + 1):
				encode_repertoire.append(String.chr(code_point))
		
		var num_z_bits = BITS_PER_CHAR - BITS_PER_BYTE * r
		lookup_e[num_z_bits] = encode_repertoire
		for z in encode_repertoire.size():
			lookup_d[encode_repertoire[z]] = [num_z_bits, z]

## Converts a PackedByteArray into a compressed String.
## [br]
## The PackedByteArray has to be a String represented in utf8.
func encode(data : PackedByteArray) -> String:
	var length : int = data.size()
	var str : String = ""
	var z = 0
	var num_z_bits = 0
	
	for i in length:
		var uint8 = data[i]
		for j in range(BITS_PER_BYTE - 1, -1, -1):
			var bit = (uint8 >> j) & 1
			z = (z << 1) + bit
			num_z_bits += 1
			
			if num_z_bits == BITS_PER_CHAR:
				str += lookup_e[num_z_bits][z]
				z = 0
				num_z_bits = 0
	if num_z_bits != 0:
		while not num_z_bits in lookup_e:
			z = (z << 1) + 1
			num_z_bits += 1
		str += lookup_e[num_z_bits][z]
	return str

## Converts a Base32768 encoded string into a utf8 PackedByteArray.
## [br]
## [color=red]Warning[/color] : the function will push an error and return an empty PackedByteArray if the decoding fails.
func decode(str : String) -> PackedByteArray:
	var length : int = str.length()
	var result : PackedByteArray = PackedByteArray()
	result.resize(int(ceil(float(length * BITS_PER_CHAR) / BITS_PER_BYTE)))
	var num_uint_8s = 0
	var uint8 = 0
	var num_uint_8_bits = 0
	
	for i in length:
		var chr = str[i]
		if not chr in lookup_d:
			push_error("Unrecognised Base32768 character: " + str(chr))
			return PackedByteArray()
		var num_z_bits = lookup_d[chr][0]
		var z = lookup_d[chr][1]
		if num_z_bits != BITS_PER_CHAR && i != length - 1:
			push_error("Secondary character found before end of input at position : " + str(i))
			return PackedByteArray()
		for j in range(num_z_bits - 1, -1, -1):
			var bit = (z >> j) & 1
			uint8 = (uint8 << 1) + bit
			num_uint_8_bits += 1
			if num_uint_8_bits == BITS_PER_BYTE:
				result[num_uint_8s] = uint8
				num_uint_8s += 1
				uint8 = 0
				num_uint_8_bits = 0
	if uint8 != ((1 << num_uint_8_bits) - 1):
		push_error("Padding mismatch")
		return PackedByteArray()
	return result

## Returns a string as an array containing each characters.
## [br]
## Maybe I'm dumb but I didn't see any built-in function that did the same thing ?
func get_array_from_string(input : String) -> Array[String]:
	var rep : Array[String] = []
	for i in input.length():
		rep.append(input[i])
	return rep

pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
#include ./tbl_deserialize.lua
#include ./tbl_serialize.lua

tbl1 = {
	true,
	false,
	3,
	"four",
	"binarystring\31\30\6\21\\2\3\23\4\0",
	foo = "bar",
	{
		true,
		false,
		3,
		"four",
		"binarystring\31\30\6\21\\2\3\23\4\0",
		foo = "bar",
		{
			true,
			false,
			3,
			"four",
			"binarystring\31\30\6\21\\2\3\23\4\0",
			foo = "bar"
		}
	}
}

str = tbl_serialize(tbl1)

tbl2 = tbl_deserialize(str)

tbl_serialize_validate(tbl1, tbl2)

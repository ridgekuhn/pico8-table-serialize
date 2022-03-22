# pico8-table-serialize #

Table serializer inspired by [this pull request](https://github.com/benwiley4000/pico8-table-string/pull/1) for [pico8-table-string](https://github.com/benwiley4000/pico8-table-string).

Supports indexed and/or keyed tables containing string, number, and boolean values. Also supports nested tables.

## Caveats ##

* Usually persists a table using less characters than pico8-table-string, but costs 14 tokens more to deserialize.

* If your table is primarily string values containing ASCII control characters, eg binary data, it may actually consume more characters than pico8-table-string.

* Will fail if a string value contains the ASCII sequence `\3\120\23`, which is used to delimit the end of a string value.

## Usage ##

### Serialize ###

Before placing output from `tbl_serialize()` in your code, it will need to be escaped using something like [escape_binary_str()](https://www.lexaloffle.com/bbs/?tid=38692).

```lua
-- define a table
my_table = {
	1,
	"two",
	true,
	foo = "bar",
	nested = {
		biz = "baz"
	}
}

-- serialize
output = tbl_serialize(my_table)

-- optional,
-- validate output
tbl_serialize_validate(
	my_table,
	tbl_deserialize(output)
)

-- print to host
printh(
	escape_binary_str(output),
	"@clip"
)
```

### Deserialize ###

```lua
my_table = tbl_deserialize(str)
```

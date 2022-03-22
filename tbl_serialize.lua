---serialize lua table to string
--@param {table} tbl
--	input table
--
--@returns {string}
--	serialized table
function tbl_serialize(tbl)
	local function encode_value(value)
		--ascii unit separator
		--delimits number
		local value_token = "\31"

		--ascii acknowledge
		--delimits true boolean
		local bool_true = "\6"

		--ascii negative acknowledge
		--delimits false boolean
		local bool_false = "\21"

		--ascii start of text
		--delimits start of string
		local str_token = "\2"

		--end of string sequence
		--ascii end of text + x
		--ascii end of transmission block
		local str_end_token = "\3x\23"

		--asci group separator
		--delimits start of table
		local tbl_token = "\29"

		if type(value) == "boolean" then
			return value and bool_true or bool_false

		elseif type(value) == "string" then
			--check for
			--ascii control chars
			for i = 1, #value do
				if ord(sub(value, i, i)) < 32 then
					--delimit binary string
					return str_token .. value .. str_end_token
				end
			end

			--encode regular string
			return value_token .. value

		elseif type(value) == "table" then
			return tbl_token .. tbl_serialize(value)
		end

		return value_token .. value
	end

	local str = ""

	--ascii record separator
	--delimits table key
	local key_token = "\30"

	--ascii end of medium
	--delimits end of table
	local tbl_end_token = "\25"

	--get indexed values
	for _, v in ipairs(tbl) do
		str = str .. encode_value(v)
	end

	--get keyed values
	for k, v in pairs(tbl) do
		if type(k) ~= "number" then
			str = str .. key_token .. k .. encode_value(v)
		end
	end

	str = str .. tbl_end_token

	return str
end

---validate output
--@usage
--	output = tbl_serialize(my_table)
--
--	tbl_serialize_validate(
--		my_table,
--		tbl_deserialize(output)
--	)
--
--@param {table} tbl1
--	input table
--
--@param {table} tbl2
--	output table
function tbl_serialize_validate(tbl1, tbl2)
	for k, v in pairs(tbl1) do
		if type(v) == "table" then
			tbl_serialize_validate(tbl2[k], v)
		else
			assert(
				tbl2[k] == v,
				tostr(k) .. ": " .. tostr(v) .. ": " .. tostr(tbl2[k])
			)
		end
	end
end

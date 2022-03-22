---deserialize table
--@param {string} str
--	serialized table string
--
--@returns {table}
--	deserialized table
function tbl_deserialize(str)
	---get encoded value
	--@param {string} str
	--	serialized table string
	--
	--@param {integer} i
	--	position of
	--	current delimiter
	--	in serialized table string
	local function get_value(str, i)
		local
			char,
			i_plus1
			=
			sub(str, i, i),
			i + 1

		--table
		if char == "\29" then
			local
				tbl,
				j
				=
				tbl_deserialize(
					sub(str, i_plus1)
				)

			return tbl, i + j

		--binary string
		elseif char == "\2" then
			for j = i_plus1, #str do
				if sub(str, j, j + 2) == "\3x\23" then
					return sub(str, i_plus1, j - 1), j + 2
				end
			end

		--bool true
		elseif char == "\6" then
			return true, i

		--bool false
		elseif char == "\21" then
			return false, i
		end

		--number, string,
		--or table key
		--("\30" or "\31")
		for j = i_plus1, #str do
			if ord(sub(str, j, j)) < 32 then
				local value = sub(str, i_plus1, j - 1)

				return tonum(value) or value, j - 1
			end
		end
	end

	local
		tbl,
		i
		=
		{},
		1

	--loop start
	::parse::

	local char = sub(str, i, i)

	--end of table
	if char == "\25" then
		return tbl, i

	--table key
	elseif char == "\30" then
		local key, j = get_value(str, i)
		local value, k = get_value(str, j + 1)

		tbl[key] = value

		i = k + 1

	--value
	elseif ord(char) < 32 then
		local value, j = get_value(str, i)

		add(tbl, value)

		i = j + 1
	end

	--loop end
	goto parse

	return tbl
end

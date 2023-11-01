Memory = {
	ROM = 0x0,
	VRAM = 0x80,
	CARTRAM = 0xA0,
	WRAM = 0xC0,
	OAM = 0xFE,
	SYS_BUS = 0xFF
}

-- Pokemon Crystal Memory Accessor
function Memory:read(addr, size, memdomain)
	--[[
		Access data from the game's memory

		In most cases, you are good to pass in the memory address and the memdomain 
		can be determined by the MSB of the address. This isn't always the case with
		CartRAM and WRAM which have 2KiB swappable partitions that may contain addresses
		that exceed their usual bounds. In this case, then the memdomain will need to be 
		set through the arguments

		Arguments:
			- addr: Global addr to read from
			- size: Number of bytes to read
			- memdomain (optional): The memory domain to read from
	]]
	local mem = ""
	local value = 0

	if memdomain == nil then
    	memdomain = (addr >> 8)
	end
	if type(memdomain) == "string" then
		memdomain = Memory[memdomain]
	end

	if memdomain == 0x0 then
		mem = "ROM"
	elseif memdomain == 0x80 then
		mem = "VRAM"
	elseif memdomain == 0xA0 then -- Domain is A000 - BFFF. But has 8 2 KiB swappable partitions
		mem = "CartRAM"
	elseif memdomain >= 0xC0 and memdomain <= 0xDF then
		mem = "WRAM"
		addr = addr - 0xC000
	elseif memdomain == 0xFE then
		mem = "OAM"
    elseif memdomain == 0xFF then
        mem = "System Bus"
	end
	addr = (addr & 0xFFFF)
	if size == 1 then
		value = memory.read_u8(addr, mem)
	elseif size == 2 then
		value = memory.read_u16_be(addr, mem)
	elseif size == 3 then
		value = memory.read_u24_be(addr, mem)
    elseif size == 4 then
		value = memory.read_u32_be(addr, mem)
	end 

	return value
end

function Memory:readFromTable(args)
	--[[
		Read from memory given a table

		Arguments:
			- addr: Address to read from
			- size: Number of bytes to read
			- memdomain (optional): The memory domain to read from
	]]
	-- Reroute request to readBitFromTable
	if args.bit ~= nil then
		return Memory:readBitFromTable(args)
	end
	if args.addr == nil then
		Log:error("No property 'addr' in table")
		return nil
	else
		addr = args.addr
	end

	if args.size == nil then
		Log:error("No property 'size' in table")
		return nil
	else
		size = args.size
	end

	local memdomain = args.memdomain
	return Memory:read(addr, size, memdomain)
end

function Memory:readdword(addr)
	return Memory:read(addr, 4)
end

function Memory:readword(addr)
	return Memory:read(addr, 2)
end

function Memory:readbyte(addr)
	return Memory:read(addr, 1)
end

function Memory:readBit(addr, bit, memdomain)
	local value = Memory:read(addr, 1, memdomain)
	return (value >> bit) & 0x1
end

function Memory:readBitFromTable(args)
	local addr = 0
	local bit = 0
	if args.addr == nil then
		Log:error("No property 'addr' in table")
		return nil
	else
		addr = args.addr
	end

	if args.bit == nil then
		Log:error("No property 'bit' in table")
		return nil
	else
		bit = args.bit
	end
	local memdomain = args.memdomain

	return Memory:readBit(addr, bit, memdomain)
end
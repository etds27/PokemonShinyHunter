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
	mem = ""
	if memdomain == nil then
    	memdomain = (addr >> 8)
	end
	if memdomain == 0x0 then
		mem = "ROM"
	elseif memdomain == 0x80 then
		mem = "VRAM"
	elseif memdomain == 0xA0 then -- Domain is A000 - BFFF. But has 8 2 KiB swappable partitions
		mem = "CartRAM"
	elseif memdomain >= 0xC0 and memdomain <= 0x13F then
		mem = "WRAM"
		addr = addr - 0xC000
	elseif memdomain == 0xFE then
		mem = "OAM"
    elseif memdomain == 0xFF then
        mem = "System Bus"
	end
	addr = (addr & 0xFFFF)
	if size == 1 then
		return memory.read_u8(addr, mem)
	elseif size == 2 then
		return memory.read_u16_be(addr, mem)
	elseif size == 3 then
		return memory.read_u24_be(addr, mem)
    elseif size == 4 then
		return memory.read_u32_be(addr, mem)
	end 
end

function Memory:readFromTable(args)
	--[[
		Read from memory given a table

		Arguments:
			- addr: Address to read from
			- size: Number of bytes to read
	]]
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
	return Memory:read(addr, size)
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

function unix_findcpuflag(flags, fallback::String)
	cpuinfo = readstring(`cat /proc/cpuinfo`);
	cpu_flags = split(match(r"flags\t\t: (.*)", cpuinfo).captures[1])
	for flag in flags
		if flag in cpu_flags
			return flag
		end
	end
	return fallback
end


"""Returns the earliest flag in the list of `flags`, that the cpu supports.
If it supports none of them, returns `fallback`.
If `envar` is set then that will override detecting the flags,
and the envar value will just be returned (if valid).
"""
function find_cpuflag(flags, fallback::String, envar)
	flaglist = join(["\"$a\"" for a in flags], ", ")
	if haskey(ENV, envar)
		if ENV[envar] in flags || ENV[envar] == fallback
			return ENV[envar]
		else
			error("Enviroment variable `$envar` was set to \"$(ENV[envar])\":\nvalid values are \"$flaglist\" or \"$fallback\"\n. Delete the enviroment variable to use automatic detection.")
		end
	end

	### Detect
	if is_unix()
		unix_findcpuflag(flags, fallback)
	else
		#Windows
		@assert is_windows()
		warn("Architecture Detection not supported on windows.\nDefaulting to \"$fallback\".\nPlease set enviroment variable `$envar`, to on of $flaglist\" or \"$fallback\"")
		return fallback
	end
end

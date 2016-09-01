function cpu_flags()
	if is_linux()
		cpuinfo = readstring(`cat /proc/cpuinfo`);
		cpu_flag_string = match(r"flags\t\t: (.*)", cpuinfo).captures[1]
	elseif is_apple()
		sysinfo = readstring(`sysctl -a`);
		cpu_flag_string = match(r"machdep.cpu.features: (.*)", cpuinfo).captures[1]
	else
		@assert is_windows()
		warn("CPU Feature detection does not work on windows.")
		cpu_flag_string = ""
	end
	split(lowercase(cpu_flag_string))
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
	available_cpu_flags = cpu_flags()
	if length(available_cpu_flags)==0
		warn("Architecture Detection Failed.\nDefaulting to \"$fallback\".\nPlease set enviroment variable `$envar`, to one of $flaglist\" or \"$fallback\"")
		return fallback
	end

	#It worked
	for flag in flags
		if flag in available_cpu_flags
			return flag
		end
	end
	return fallback
end

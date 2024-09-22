https://stackoverflow.com/tags/x86/info

x86 is an architecture derived from the Intel 8086 CPU. The x86 family includes the 32-bit IA-32 and 64-bit x86-64 architectures, as well as legacy 16-bit architectures. Questions about the latter should be tagged [x86-16] and/or [emu8086]. Use the [x86-64] tag if your question is specific to 64-bit x86-64. For the x86 FPU, use the tag [x87]. For SSE1/2/3/4 / AVX* also use [sse], and any of [avx] / [avx2] / [avx512] that apply

The x86 family of CPUs contains 16-, 32-, and 64-bit processors from several manufacturers, with backward-compatible instruction sets, going back to the Intel 8086 introduced in 1978.

There is an [x86-64](https://stackoverflow.com/questions/tagged/x86-64 "show questions tagged 'x86-64'") tag for things specific to that architecture, but most of the info here applies to both. It makes more sense to collect everything here. Questions can be tagged with either or both. Questions specific to features only found in the x86-64 architecture, like RIP-relative addressing, clearly belong in `x86-64`. Questions like "how to speed up this code with vectors or any other tricks" are fine for `x86`, even if the intention is to compile for 64bit.

Related tag with tag-wikis:

- [sse](https://stackoverflow.com/questions/tagged/sse "show questions tagged 'sse'") [wiki](https://stackoverflow.com/tags/sse/info) (some good SIMD guides), and [avx](https://stackoverflow.com/questions/tagged/avx "show questions tagged 'avx'") ([not much there](https://stackoverflow.com/tags/avx/info))
- [inline-assembly](https://stackoverflow.com/questions/tagged/inline-assembly "show questions tagged 'inline-assembly'") [wiki](https://stackoverflow.com/tags/inline-assembly/info) for guides specific to interfacing with a compiler that way.
- [intel-syntax](https://stackoverflow.com/questions/tagged/intel-syntax "show questions tagged 'intel-syntax'") [wiki](https://stackoverflow.com/tags/intel-syntax/info) and [att](https://stackoverflow.com/questions/tagged/att "show questions tagged 'att'") [wiki](https://stackoverflow.com/tags/att/info) have more details about the differences between the two major x86 assembly syntaxes. And for Intel, how to spot which flavour of Intel syntax it is, like NASM vs. MASM/TASM.

**Learning resources**

- **Matt Godbolt's CppCon2017 talk [“What Has My Compiler Done for Me Lately? Unbolting the Compiler's Lid”](https://youtu.be/bSkpMdDe4g4)** has a gentle introduction to x86 asm itself for asm beginners who know C or C++, as well a very useful guide to looking at compiler output.
    
    **If you don't know how to do something in asm, write a simple C function that does it and see what an optimizing compiler does**. e.g. `int foo(char *p) { return *p; }` shows you how to use `movsx`. See also [How to remove "noise" from GCC/clang assembly output?](https://stackoverflow.com/questions/38552116/how-to-remove-noise-from-gcc-clang-assembly-output)
    
- Short [x86 Assembly Guide](http://www.cs.virginia.edu/%7Eevans/cs216/guides/x86.html) targetting 32 bit mode and MASM assembler, but being brief and target-agnostic enough to be used as a starting point for any "Intel" syntax dialect assembler (NASM, YASM, FASM, ...).
    
- [Suggestions on how to learn asm, with a recommendation against 16bit DOS](https://stackoverflow.com/a/34918617). Questions should use the [x86-16](https://stackoverflow.com/questions/tagged/x86-16 "show questions tagged 'x86-16'"), [emu8086](https://stackoverflow.com/questions/tagged/emu8086 "show questions tagged 'emu8086'"), and/or [dos](https://stackoverflow.com/questions/tagged/dos "show questions tagged 'dos'") tags if applicable, as well as [x86](https://stackoverflow.com/questions/tagged/x86 "show questions tagged 'x86'") (which includes all platforms.)
    
- [To learn assembly - should I start with 32 bit or 64 bit?](https://stackoverflow.com/questions/2352048/to-learn-assembly-should-i-start-with-32-bit-or-64-bit)
    
- **[OSdev.org](http://wiki.osdev.org/)**: a great resource if you want to understand / modify OS internals or make your own toy OS. Not useful for writing / debugging normal programs that run under existing OSes.
    
- [General Tips for Bootloader Development](https://stackoverflow.com/questions/32701854/boot-loader-doesnt-jump-to-kernel-code/32705076#32705076). (Using legacy BIOS, not UEFI).
    
- [Working example of a legacy BIOS `int 10h` bootloader that loads a "kernel" and calls a C `main` function in it, in 32-bit protected mode](https://stackoverflow.com/questions/33603842/how-to-make-the-kernel-for-my-bootloader/33619597#33619597). Includes instructions on how to build and link it with NASM, `gcc -m32`, and `ld` (with a linker script). And how to make a disk image and run it on QEMU.
    
- the [inline-assembly](https://stackoverflow.com/questions/tagged/inline-assembly "show questions tagged 'inline-assembly'") tag [wiki](https://stackoverflow.com/tags/inline-assembly/info). (But see also [https://gcc.gnu.org/wiki/DontUseInlineAsm](https://gcc.gnu.org/wiki/DontUseInlineAsm) - inline asm is _more_ complicated than writing stand-alone asm functions you call from C, so it's not good for learning asm.)
    
- [Using GNU C/C++ inline ASM](https://stackoverflow.com/questions/34520013/using-base-pointer-register-in-c-inline-asm/34522750#34522750). The bottom of that answer has a collection of links to info on how to write inline asm that's efficient and correct. The first part of the answer explains why it's **_not_ a good way to learn asm in the first place**. Don't try to "get your feet wet" with asm by using inline asm. You have to understand everything to write correct input/output operand constraints and clobbers.
    
- **[Understanding Carry vs. Overflow conditions/flags](http://teaching.idallen.com/dat2343/10f/notes/040_overflow.txt)**, normally relevant for unsigned vs. signed respectively.
    
- Style guide: indenting columns for labels / instructions / operands / comments: a Code Review.SE answer: [https://codereview.stackexchange.com/questions/204902/checking-if-a-number-is-prime-in-nasm-win64-assembly/204965#204965](https://codereview.stackexchange.com/questions/204902/checking-if-a-number-is-prime-in-nasm-win64-assembly/204965#204965)
    

- [Quick guide to what's different in x86-64](https://web.archive.org/web/20160609221003/http://www.x86-64.org/documentation/assembly.html). AT&T syntax. NASM and YASM behave differently (from each other) in choice of encoding for `mov rax, 1`, and don't use a separate `movabs` mnemonic for the 64bit-immediate form.
- [**Introduction to x64 Assembly** (PDF published by Intel)](https://www.intel.com/content/dam/develop/external/us/en/documents/introduction-to-x64-assembly-181178.pdf). Uses MASM syntax. Spends a bit of time talking about the Windows calling convention and / MSVC-specific toolchain issues (like no MSVC inline asm in 64-bit mode), as you might expect from using "x64" in the article title instead of x86-64. But looks like some good generally-applicable stuff that isn't OS-specific. For some bizarre reason, it suggests using the [slow LOOP instruction](https://stackoverflow.com/questions/35742570/why-is-the-loop-instruction-slow-couldnt-intel-have-implemented-it-efficiently), so it's not perfect.
- A [NASM tutorial](https://cs.lmu.edu/%7Eray/notes/nasmtutorial/) for x86-64 Linux (`nasm -felf64`) and MacOS (`nasm -fmacho64`). Includes some basic SIMD stuff, but forgets to use `alignas(16)` on the C arrays that require alignment, and uses `movaps` with integer, `movdqa` with float. (Which is not a correctness problem, and on most CPUs probably not a performance problem, but is backwards.) Otherwise mostly looks good.
- [Encoding Real x86 Instructions](http://www.c-jump.com/CIS77/CPU/x86/index.html): a tutorial (course material) on how instructions are encoded into machine code. Lots of diagrams.
- [x86 on Wikipedia](https://en.wikipedia.org/wiki/X86)
- [x86 Assembly wikibook](https://en.wikibooks.org/wiki/X86_Assembly)
- [Assembly Language for x86 Processors (website for Kip Irvine's book)](http://kipirvine.com/asm/)
- **[Programming from the Ground Up](https://savannah.nongnu.org/projects/pgubook/), a free (GFDL) book** by Jonathan Bartlett. [Errata for the book](https://savannah.nongnu.org/bugs/?group=pgubook). Available as a small (1MB) PDF from the "download" link on that page, or [as HTML chapters](https://programminggroundup.blogspot.com/2007/01/chapter-1-introduction.html) . It uses 32-bit x86 asm with AT&T syntax on Linux, and has some good stuff about how to "think like a computer" to figure out how to get things done in asm. It covers some essential operating-system stuff like virtual memory, and things like that necessary to understand what's going on, as well as assembly / machine language itself.
- [x86-64 Assembly Language Programming with Ubuntu](http://www.egr.unlv.edu/%7Eed/x86.html), a free book using YASM (NASM syntax) for GNU/Linux. The PDF is CC-BY-NC-SA. Unfortunately no mention of `default rel` or `[rel x]` RIP-relative addressing so it's missing some stuff that's essential in practice. But does have some introductory stuff about basics like data representation, bits and bytes in memory vs. registers, and other background beyond just what each instruction does.
- [8086 assembler tutorial for beginners](https://jbwyatt.com/253/emu/tutorials.html) - emu8086 (MASM/TASM style) 16-bit only, but starts out with some nice intro stuff about hex vs. decimal, what assembly language is, what registers are and how memory is addressed, and how to look at memory in the debugger, before jumping into how specific instructions work.
- [Assembly tutorial - Dr. Paul Carter](https://pacman128.github.io/pcasm/)
- [Windows Assembly Programming Tutorial](https://www-s.acm.illinois.edu/sigwin/old/workshops/winasmtut.pdf)
- [Why do functions have to save some registers, but not others?](https://stackoverflow.com/questions/8335582/why-does-ia-32-have-a-non-intuitive-caller-and-callee-register-saving-convention) See below for links to guides & docs for specific calling conventions.
- [How to trace what a function does](https://stackoverflow.com/questions/37531709/tracing-a-ncr-assembly-program-of-masm/37534836#37534836): figure out the inputs and the outputs, then figure out what it does with them.
- [Linux x86 Program Start Up or - How the heck do we get to main()](http://dbp-consulting.com/tutorials/debugging/linuxProgramStartup.html)
- [A Whirlwind Tutorial on Creating Really Teensy ELF Executables for Linux](http://www.muppetlabs.com/%7Ebreadbox/software/tiny/teensy.html)
- [What do the register-names like `esi` mean, and what special purposes do they have](http://www.swansontec.com/sregisters.html). They're all acronyms, like Counter register, or Source Index.

---

Guides for **performance tuning** / optimisation:

- **[Agner Fog's optimization guides and resources](https://www.agner.org/optimize/)**. Includes latency/throughput tables for P5 onwards. Also _much_ qualitative discussion of how to go about making your code faster. Also has a good guide to the different calling conventions across OSes, and covers linking / symbols / relocation.
- Intel's Sandybridge microarchitecture family [can't micro-fuse indexed addressing modes in the out-of-order core](https://stackoverflow.com/questions/26046634/micro-fusion-and-addressing-modes/31027695#31027695), only in the decoders and uop-cache. Also: Haswell's dedicated store-address unit on port7 only works with simple effective addresses. Complex effective addresses need the AGU on a load port.
- [Enhanced REP MOVSB for memcpy](https://stackoverflow.com/questions/43343231/enhanced-rep-movsb-for-memcpy): single-threaded bandwidth vs. aggregate bandwidth on desktop vs. many-core CPUs, RFO vs. non-RFO stores. (Modern CPUs have more DRAM / L3 bandwidth than a single core can use; there are other bottlenecks especially in many-core chips).
- **[What Every Programmer Should Know About Memory](https://www.akkadia.org/drepper/cpumemory.pdf)** by Ulrich Drepper. (Originally posted as [a series of LWN articles](https://lwn.net/Articles/250967/), Ulrich published the PDF later). How DRAM and caches work, their behaviour, and how to optimize software for cache locality. Includes some charts with real microbenchmark data to illustrate points, and **a cache-blocked SSE2 matrix multiply example**. See [a 2017 review of what's outdated](https://stackoverflow.com/questions/8126311/what-every-programmer-should-know-about-memory/47714514#47714514), e.g. the P4 software prefetch stuff is mostly obsolete.
- [Why `xor same,same` is better than `mov reg, 0` for zeroing a register](https://stackoverflow.com/a/33668295) There are several reasons, some simple and some subtle (e.g. avoiding partial-register stalls on P6/SnB family).
- [Serializing RDTSC with LFENCE vs. CPUID](http://akaros.cs.berkeley.edu/lxr/akaros/kern/arch/x86/rdtsc_test.c) for benchmarking short sequences within a program.
- [How to get the CPU cycle count in x86_64 from C++?](https://stackoverflow.com/questions/13772567/get-cpu-cycle-count/51907627#51907627) (including a bunch of info on what `rdtsc` measures, exactly, and caveats for using it, with links to even more details).
- [What considerations go into predicting latency for operations on modern superscalar processors and how can I calculate them by hand?](https://stackoverflow.com/questions/51607391/what-considerations-go-into-predicting-latency-for-operations-on-modern-supersca): intro to static performance analysis.
- [Intel's IACA](https://software.intel.com/en-us/articles/intel-architecture-code-analyzer) (Intel Architecture Code Analyzer): analyze marked sections of code for throughput (e.g. cycles per iteration) or latency of the critical path. Assumes perfect cache, and other simplifications, and isn't always correct, but can be useful. Was stalled, but updated again for Skylake-X (AVX512). See [What is IACA and how do I use it?](https://stackoverflow.com/questions/26021337/what-is-iaca-and-how-do-i-use-it) for a tutorial.
- [uiCA (uops.info Code Analyzer)](https://github.com/andreas-abel/uiCA) is like IACA but with an accurate model of the front-end fetch/pre-decode/decode (and uop cache or LSD if applicable, I assume) not just 4-wide or 5-wide issue that IACA assumes. See [Do 32-bit and 64-bit registers cause differences in CPU micro architecture?](https://stackoverflow.com/questions/70131766/do-32-bit-and-64-bit-registers-cause-differences-in-cpu-micro-architecture) for an example output graph.
- [Haswell microarchitecture](http://www.realworldtech.com/haswell-cpu/), [Bulldozer microarchitecture](https://www.realworldtech.com/bulldozer/). David Kanter's analysis. He's also done writeups on earlier uarches, like Sandybridge and Nehalem.
- A series of articles on Zen 4: [1](https://chipsandcheese.com/2022/11/05/amds-zen-4-part-1-frontend-and-execution-engine/) [2](https://chipsandcheese.com/2022/11/08/amds-zen-4-part-2-memory-subsystem-and-conclusion/) [3](https://chipsandcheese.com/2023/01/05/amds-zen-4-part-3-system-level-stuff-and-igpu/), from **Chips & Cheese**, aiming for the same style of deep-dive as David Kanter's articles on Realworldtech. (That site has lots of technical articles about other recent x86 microarchitectures, and some interesting historical looks at important uarches. Also some ARM and RISC-V.)
- Wikichip has pages on recent x86 uarches, like a [Zen 2](https://en.wikichip.org/wiki/amd/microarchitectures/zen_2) deep dive. Some other pages are just short change lists vs. the previous in the same family.
- [**Modern Microprocessors A 90-Minute Guide!**](http://www.lighterra.com/papers/modernmicroprocessors/): from in-order pipelined to super-scalar out-of-order. And brainiac (PPro) vs. speed demon (Pentium 4), and Pentium 4 hitting the "power wall" in CPU design.
- [A whirlwind introduction to dataflow graphs](https://fgiesen.wordpress.com/2018/03/05/a-whirlwind-introduction-to-dataflow-graphs/): how to analyze dependency chains for throughput and latency.
- **[http://www.uops.info/](http://www.uops.info/)** very detailed uop / execution port testing on Intel CPUs, finding some things that repeating a large block of the same instruction (like Agner Fog's testing) sometimes misses.
- New CPUs will usually have **[AIDA64 InstLatx64 results](http://users.atw.hu/instlatx64/)** before Agner Fog can test and publish updated tables. For example, [Skylake-avx512](https://github.com/InstLatx64/InstLatx64/blob/master/GenuineIntel0050654_SkylakeX_InstLatX64.txt), and see also [https://github.com/InstLatx64/InstLatx64](https://github.com/InstLatx64/InstLatx64) for a mirror + a spreadsheet of Skylake-AVX512 port assignments (compiled from IACA-2.3 output). [BDW vs. SKL](https://github.com/InstLatx64/InstLatx64/blob/master/HSWvsBDWvsSKL.txt) points out some of the interesting changes in SKL (more throughput for more instructions, different FP latency).
- [2015 IDF slides from the Skylake power management talk](https://en.wikichip.org/wiki/File:Intel_Architecture,_Code_Name_Skylake_Deep_Dive-_A_New_Architecture_to_Manage_Power_Performance_and_Energy_Efficiency.pdf) Unfortunately the main site ([http://myeventagenda.com/sessions/0B9F4191-1C29-408A-8B61-65D7520025A8/7/5](http://myeventagenda.com/sessions/0B9F4191-1C29-408A-8B61-65D7520025A8/7/5)) which had video (of slides + audio) is offline now.

**Instruction set** / asm syntax references:

- **[Intel's vector intrinsics finder/search (very good)](https://software.intel.com/sites/landingpage/IntrinsicsGuide/)**: search by asm mnemonic or C intrinsic name
    
- [x86/x64 SIMD Instruction List (SSE to AVX512) Beta](http://www.officedaytime.com/simd512e/simd.html): A nice compact table listing instruction mnemonics and their intrinsics, broken down by type and element-size. Detailed pages with graphical data-movement diagrams for each instruction.
    
- **[SIMD guides in the SSE tag wiki](https://stackoverflow.com/tags/sse/info)**, focusing on how to actually make good use of SIMD in general, not just what the available instructions are.
    
- **[Intel's manuals, including instruction set reference manual](https://www-ssl.intel.com/content/www/us/en/processors/architectures-software-developer-manuals.html). Extremely detailed description** of everything every instruction does to the architectural state. Big, but has a decent index / table of contents. Also on that page: **Intel's optimization manual**. Some of the same advice as Agner Fog's guides, but sometimes without explaining exactly why in terms of microarch execution ports and other under-the-hood reasons. Also sometimes obsolete, for example recommending against `inc`/`dec` long after P4 is irrelevant.
    
- **[AMD's x86 manuals](https://developer.amd.com/resources/developer-guides-manuals/)**, including instruction-set reference and optimization manuals.
    
- [HTML version of Intel's insn set reference](http://www.felixcloutier.com/x86/), auto-generated from the PDF. One page per instruction, great for linking in answers.
    
- [Another HTML extract, including AVX512, CLFLUSHOPT, etc.](https://hjlebbink.github.io/x86doc/). This makes it more cluttered, and harder to find what you need, if you're _not_ targeting AVX512. (But note that [CLFLUSH has changed to being strongly-ordered](https://stackoverflow.com/a/40147977), but felixcloutier.com's HTML extract still has the old documentation. There may be other inaccuracies in the old docs, even for old instructions.)
    
- [https://sandpile.org](https://sandpile.org/) - CPUID maps, instruction encoding, register diagrams, opcode map, miscellaneous other technical details.
    
- [x86 Instruction Reference **including when introduced (8086, 186, 586, etc)** - NASM appendix B](https://nasm.us/doc/nasmdocb.html). Includes undocumented instructions, and Cyrix-only MMX instructions, and stuff like that.
    
    [A fork of an older version](https://pushbx.org/ecm/doc/insref.htm) includes English descriptions. The original had some errors in which generation introduced each form of each insn but this version keeps the nice formatting while fixing those. Handy for people still developing for [x86-16](https://stackoverflow.com/questions/tagged/x86-16 "show questions tagged 'x86-16'"). The similar [wikipedia page](https://en.wikipedia.org/wiki/X86_instruction_listings#Added_in_specific_processors) doesn't mention that 386 is required for the faster 2-operand form of `imul r16, r/m16` that doesn't have to calculate the upper half of the result.
    
- [x86 Opcode reference guide](http://ref.x86asm.net/), sorted by opcode or by mnemonic. 32, 64, or both in one table. The "geek" version includes non-standard / undocumented opcodes, the "coder" one includes columns showing which if any flags are read and written.
    
- [Original 8086 errata / anomalies](https://www.pcjs.org/pubs/pc/reference/intel/8086/), such as `mov ss, src` not properly disabling interrupts until the end of the next instruction. Also see the parent directory for some errata, undocumented instructions, and stuff for 186/286/386.
    
- **[Simply FPU: x87 tutorial](http://www.ray.masmcode.com/tutorial/index.html)**. Helpful for understanding old x87 code, esp. the early sections about how the register stack works. (Use SSE for new code.)
    
- [`fsin`'s precision is _far_ worse than 1ulp for inputs close to pi](https://randomascii.wordpress.com/2014/10/09/intel-underestimates-error-bounds-by-1-3-quintillion/), contrary to Intel's previous documentation. The other FP articles in Bruce Dawson's series are also excellent ([index in this one](https://randomascii.wordpress.com/2012/02/25/comparing-floating-point-numbers-2012-edition/) on FP comparisons).
    
- [GNU `as` manual, aka gas manual](https://sourceware.org/binutils/docs/as/)
    
- [The NASM manual](http://www.nasm.us/doc/)
    
- [YASM manual](https://www.tortall.net/projects/yasm/manual/html/index.html): describes YASM syntax and macros. [Excellent **register diagram**](https://www.tortall.net/projects/yasm/manual/html/manual.html#x86-registers) showing partial registers, with their machine-code encodings, and a reminder on zero-extending vs. unmodified upper parts. (Another simpler [register-subset diagram](https://stackoverflow.com/a/37275984) for a single reg).
    
    Possible canonical duplicates for register subsets: [Assembly registers in 64-bit architecture](https://stackoverflow.com/questions/20637569/assembly-registers-in-64-bit-architecture) includes some calling-convention / usage stuff. [How do AX, AH, AL map onto EAX?](https://stackoverflow.com/questions/15191178/how-do-ax-ah-al-map-onto-eax) is a good one for bugs where AL and RAX were used for different things, corrupting each other.
    
- [MASM Reference Documentation](https://msdn.microsoft.com/en-us/library/afzk3475.aspx), and an old [MASM 6.1 manual from 1996](http://people.sju.edu/%7Eggrevera/arch/references/MASM61PROGUIDE.pdf). [Confusing brackets in MASM32](https://stackoverflow.com/questions/25129743/confusing-brackets-in-masm32/25130189#25130189) shows that MASM surprisingly ignores brackets around symbolic immediates.
    
- [MASM syntax as used by JWasm](http://wiki.osdev.org/JWasm). [JWasm is a portable assembler](https://github.com/JWasm/JWasm).
    
- [FASM manual](https://flatassembler.net/docs.php?article=manual)
    
- [table of AT&T(GNU) vs. NASM syntax for addressing modes and indirect `jmp`/`call`](https://stackoverflow.com/a/6820015)
    
- [All the available addressing modes (32/64-bit)](https://stackoverflow.com/a/34058400) (Intel syntax, with a note about NASM vs. MASM for `mov reg, symbol`), with links to further guides.
    
- [AT&T addressing-mode syntax](https://stackoverflow.com/questions/48178969/assembly-what-is-the-purpose-of-movl-data-items-edi-4-eax-in-this-program)
    
- [16-bit addressing modes](https://stackoverflow.com/questions/12474010/nasm-x86-16-bit-addressing-modes).
    
- TODO: find a good link for AMD's XOP instruction set. (Not recommended for general use; even AMD is dropping XOP support in their Zen architecture.)
    
- [Cheat sheet PDF](http://www.jegerlehner.ch/intel/)
    
- [Win32-specific cheat sheet](https://www.trgct.com/wp-content/gct-uploads/2011/03/CheatSheet.png)
    

**OS-specific stuff**: ABIs and system-call tables:

- [x86 ABIs (wikipedia)](https://en.wikipedia.org/wiki/X86_calling_conventions): calling conventions for functions, including x86-64 Windows and System V (Linux). See also [Agner Fog's nice calling convention guide](https://www.agner.org/optimize/)
- [32-bit absolute addresses no longer allowed in x86-64 Linux?](https://stackoverflow.com/questions/43367427/32-bit-absolute-addresses-no-longer-allowed-in-x86-64-linux) (PIE executables are now the default on most distros, with gcc configured with `--enable-default-pie`.)
- [Mach-O 64-bit format does not support 32-bit absolute addresses. NASM Accessing Array](https://stackoverflow.com/questions/47300844/mach-o-64-bit-format-does-not-support-32-bit-absolute-addresses-nasm-accessing) (OS X's image base is above the low 32, unlike Linux position-dependent executables). Also mentions 2 known bugs in some NASM versions with macho64 and RIP-relative or 64-bit absolute addressing.

---

- [System V ABI summary on osdev](http://wiki.osdev.org/System_V_ABI): i386 and x86-64, with links to random copies of the per-architecture supplement for various architectures, and [the generic gABI](http://www.sco.com/developers/gabi/) that all the processor-specific supplement (psABI) documents expand on.
- [System V psABI official standard current revisions for x86-64 and i386](https://github.com/hjl-tools/x86-psABI/wiki/X86-psABI) (wiki page on github, kept up to date by H.J. Lu). Direct link to [x86-64 revision 1.0](https://github.com/hjl-tools/x86-psABI/wiki/x86-64-psABI-1.0.pdf). Also links to the official forum for ABI discussion by maintainers/contributors.
- [clang/gcc sign/zero extend narrow args to 32bit](https://stackoverflow.com/questions/36706721/is-a-sign-or-zero-extension-required-when-adding-a-32bit-offset-to-a-pointer-for/36760539#36760539), even though the System V ABI as written doesn't (yet?) require it. Clang-generated code also depends on it.
- [System V 32bit (i386) psABI (official standard, rev 1.1 Dec2015)](https://github.com/hjl-tools/x86-psABI/wiki/intel386-psABI-1.1.pdf), used by Linux and Unix. (Some OSes don't require 16-byte stack alignment for 32-bit code; GNU/Linux does)  
    (Historical: very old [SCO version of the i386 SysV ABI](http://sco.com/developers/devspecs/abi386-4.pdf), before 16B stack alignment was required).

---

- [OS X 32bit x86 calling convention, with links to the others](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/LowLevelABI/130-IA-32_Function_Calling_Conventions/IA32.html). The 64bit calling convention is System V. Apple's site just links to a FreeBSD pdf for that.

---

- [Windows x86-64 `__fastcall`](https://learn.microsoft.com/en-us/cpp/build/x64-software-conventions) calling convention
    
- [Windows `__vectorcall`](https://learn.microsoft.com/en-us/cpp/cpp/vectorcall): documents the 32bit and 64bit versions
    
- [Windows 32bit `__stdcall`](https://learn.microsoft.com/en-us/cpp/cpp/stdcall): used used to call Win32 API functions. That page links to the other calling convention docs (e.g. `__cdecl`).
    
- [ABI cheat sheet: x86 vs. x64 vectorcall and non-vectorcall, vs. SysV](https://docs.google.com/spreadsheets/d/1-QLVaAa8jEqt6abbxltWU2HVlPDy1d32_7StMGJUI1k/edit#gid=0). SysV section is incomplete.
    
- [Why does Windows64 use a different calling convention from all other OSes on x86-64?](https://stackoverflow.com/questions/4429398/why-does-windows64-use-a-different-calling-convention-from-all-other-oses-on-x86): some interesting history, esp. for the SysV ABI where the mailing list archives are public and go back before AMD's release of first silicon.
    
- [MSVC's 32bit CRT startup code sets the x87 FPU precision to 53 (`double`)](https://randomascii.wordpress.com/2012/03/21/intermediate-floating-point-precision/). That entire series of articles (table of contents in [this one](https://randomascii.wordpress.com/2012/02/25/comparing-floating-point-numbers-2012-edition/)) is excellent, including asm output from MSVC in some examples.
    

---

- [**The Definitive Guide to Linux System Calls** (on x86)](https://blog.packagecloud.io/eng/2016/04/05/the-definitive-guide-to-linux-system-calls/). Examples of how to use `int 0x80`, 32-bit `sysenter`, and 64-bit `syscall`, and how to call through the vDSO for `gettimeofday`, and has some info about glibc's syscall wrappers. Lots of details, **and also some background info / basics for beginners**.
- [Linux system call tables](https://filippo.io/linux-syscall-table/). 64bit syscall numbers, with parameter->register mapping (derived from the kernel source code, and the standard rule for order of args).
- [FreeBSD system calls](https://stackoverflow.com/questions/2535989/what-are-the-calling-conventions-for-unix-linux-system-calls-on-x86-64): question has FreeBSD syscalls, answer has Linux and others.
- [What are the calling conventions for UNIX & Linux system calls (and user-space functions) on i386 and x86-64](https://stackoverflow.com/questions/2535989/what-are-the-calling-conventions-for-unix-linux-system-calls-on-x86-64): Note that 32bit `int 0x80` restores all registers (including flags) except `eax`, while 64bit `syscall` also clobbers `rcx` and `r11` as well as putting the return value in `rax`.

---

- [16bit interrupt list](http://www.ctyme.com/rbrown.htm): PC BIOS system calls (`int 10h` / `int 16h` / etc, AH=callnumber), DOS system calls (`int 21h`/AH=callnumber), and more.

**memory ordering**:

- [Weak vs. Strong Memory Models](http://preshing.com/20120930/weak-vs-strong-memory-models/): what it means when people say x86 has a "strongly ordered memory model". See also the [c++](https://stackoverflow.com/questions/tagged/c%2b%2b "show questions tagged 'c++'") info page for many good links if you're using C11/C++11 atomics.
- [Memory Reordering Caught in the Act](https://preshing.com/20120515/memory-reordering-caught-in-the-act/): A test case that demonstrates memory reordering in practice on a multicore x86 CPU.
- [A better x86 memory model: x86-TSO (extended version)](https://www.cl.cam.ac.uk/%7Epes20/weakmemory/x86tso-paper.pdf) A formal definition of the x86 memory model which hopefully matches how real hardware behaves.
- [Why isn't `add dword [num], 1` atomic, even though it's a single instruction](https://stackoverflow.com/questions/39393850/can-num-be-atomic-for-int-num). Also asks about compiling `num++` in C++. or See also [Atomicity of loads and stores on x86](https://stackoverflow.com/questions/38447226/atomicity-on-x86): What does it mean for a load or store to be atomic, and how is it implemented internally?

**Specific behaviour of specific implementations**

- [TLB and Pagewalk Coherence in x86 Processors](http://blog.stuffedcow.net/2015/08/pagewalk-coherence/). Many x86 microarchitectures, especially Intel's, provide stronger ordering guarantees than the ISA requires for modifying a page-table entry that's not already cached in the TLB. Win95 even depended on this. (Don't write new code that depends on this.)
- [Measuring Reorder Buffer Capacity](http://blog.stuffedcow.net/2013/05/measuring-rob-capacity/) Another experimental test that demonstrates the capabilities and limits of out-of-order execution in real hardware.
- [What are the exhaustion characteristics of RDRAND on Ivy Bridge?](https://stackoverflow.com/questions/14413839/what-are-the-exhaustion-characteristics-of-rdrand-on-ivy-bridge) With an answer from David Johnston (Intel RNG HW designer and `librdrand` author).

**Q&As** with good links, or directly useful answers:

- **[Using GNU C/C++ inline ASM](https://stackoverflow.com/questions/34520013/using-base-pointer-register-in-c-inline-asm/34522750#34522750)**. (Same link from the learning-resources section, but worth repeating here.)
    
- [What are the best instruction sequences to generate vector constants on the fly?](https://stackoverflow.com/questions/35085059/what-are-the-best-instruction-sequences-to-generate-vector-constants-on-the-fly)
    
- [Parallel programming using Haswell architecture](https://stackoverflow.com/questions/20933746/parallel-programming-using-haswell-architecture/20948208)
    
- [Deoptimizing a program for the pipeline in Intel Sandybridge-family CPUs](https://stackoverflow.com/questions/37361145/deoptimizing-a-program-for-the-pipeline-in-intel-sandybridge-family-cpus). Has a long answer including some introductory computer-architecture stuff as well as details of what can stall a Haswell pipeline.
    
- [INC instruction vs ADD 1: Does it matter?](https://stackoverflow.com/questions/36510095/inc-instruction-vs-add-1-does-it-matter)
    
- [How can I run this assembly code on OS X?](https://stackoverflow.com/questions/18689404): OS X getting-started guide. (Symbol names are prepended with `_` on OS X, unlike for Linux ELF systems.)
    
- [add/sub/LEA can be used with garbage in high bits](https://stackoverflow.com/questions/34377711/which-2s-complement-integer-operations-can-be-used-without-zeroing-high-bits-in), so [`LEA eax, [rdi + rsi*2 - 15]` to compute `a + 2*b - 15`](https://stackoverflow.com/a/46597375) works fine, even if `a` and `b` are only supposed to be 8 or 16 bits.
    
- TODO: find a question about how to use a profiler to measure uops and stuff. `perf` comes with most Linux distros, and [`ocperf.py`](https://github.com/andikleen/pmu-tools/blob/master/ocperf.py) is a wrapper for it that provides more symbolic names for stuff like micro-arch-specific uop counters.
    

---

## FAQs / canonical answers:

If you have a problem involving one of these issues, don't ask a new question until you've read and understood the relevant Q&A.

(TODO: find better question links for these. Ideally questions that make a good duplicate target for new dups. Also, expand this.)

- My program **crashes / segfaults**: You need to use a debugger to find what instruction is crashing (see the bottom of this tag wiki for GDB and Visual Studio tips). Most buggy asm programs crash, so without more info this is not useful. Reasons can include clobbering registers or stack memory you shouldn't have, leaving `esp` pointing to the wrong place before a `ret`, or many many other reasons besides the following other common problems.
    
- **[external assembly file in visual studio](https://stackoverflow.com/questions/33751509/external-assembly-file-in-visual-studio)** - VS mixed-source x64 project, for asm files as part of a C/C++ program.  
    Also [Assembly programming - WinAsm vs Visual Studio 2017](https://stackoverflow.com/questions/52796300/assembly-programming-winasm-vs-visual-studio-2017) for a pure asm project.
    
- **[Building 32bit code on a 64bit system](https://stackoverflow.com/questions/36861903/assembling-32-bit-binaries-on-a-64-bit-system-gnu-toolchain/36901649#36901649)** (with the GNU toolchain). `gcc example.s` makes a binary that runs in 64bit mode, which will crash if the code was written for 32bit mode. Related: [What happens if you use the 32-bit int 0x80 Linux ABI in 64-bit code?](https://stackoverflow.com/questions/46087730/what-happens-if-you-use-the-32-bit-int-0x80-linux-abi-in-64-bit-code).
    
- [Building an executable from asm source that defines `_start` vs. source that defines `main`](https://stackoverflow.com/questions/36861903/assembling-32-bit-binaries-on-a-64-bit-system-gnu-toolchain/36901649#36901649), with `gcc`/`as`/`ld` and/or NASM. With or without libc, and static vs. dynamic executable.
    
- [Wide load on narrow data](https://stackoverflow.com/questions/72863528/adding-another-word-in-data-is-messing-up-with-values-in-x86) loading or modifying extra bytes, e.g. `mov eax, [var]` from a `db 0`.
    
- **[ret from `_start` segfaults](https://stackoverflow.com/questions/19760002/nasm-segmentation-fault-on-ret-in-start)** without making a Linux `_exit` syscall. `ret` doesn't work because it's not a function. [What happens if there is no exit system call in an assembly program?](https://stackoverflow.com/questions/49674026) also covers the case of falling off the end with no `ret`.
    
    Execution just keeps going if there's no jump or ret, falling through to what's next: [What if there is no return statement in a CALLed block of code in assembly programs](https://stackoverflow.com/questions/41205054/what-if-there-is-no-return-statement-in-a-called-block-of-code-in-assembly-progr) and [Why is no value returned if a function does not explicity use 'ret'](https://stackoverflow.com/questions/20578122/why-is-no-value-returned-if-a-function-does-not-explicity-use-ret).
    
- [Code executes condition wrong?](https://stackoverflow.com/questions/32872539/code-executes-condition-wrong) fall through from the `if` into the `else` body in an `if/else`. Nicely explains that labels aren't magic and execution falls through them.
    
- [Segmentation fault when using DB (define byte) inside a function](https://stackoverflow.com/questions/55642600/segmentation-fault-when-using-db-define-byte-in-assembly-nasm) **Putting data where it's executed as code**. ([Assembly (x86): <label> db 'string',0 does not get executed unless there's a jump instruction](https://stackoverflow.com/questions/30561366/assembly-x86-label-db-string-0-does-not-get-executed-unless-theres-a-jum) for legacy BIOS bootloaders with data at the top.)
    
- **`idiv` / `div` problems**: [Zero `edx` first, or sign-extend `eax` into it.](https://stackoverflow.com/questions/38416593/why-should-edx-be-0-before-i-use-div-opcode/38416896#38416896). 32-bit `div` faults with [[DE]] if the 64b/32b => 32b quotient doesn't actually fit in 32b. (On POSIX systems including Linux, [this raises `SIGFPE`](https://stackoverflow.com/questions/37262572/on-which-platforms-does-integer-divide-by-zero-trigger-a-floating-point-exceptio)).
    
    [8-bit operand size like `div dl` is the special case](https://stackoverflow.com/a/43575674) where dx isn't involved, just AX and AH/AL. It still faults if the quotient overflows 8 bits.
    
- [No output from `printf` when I pipe the output, or print something without a newline](https://stackoverflow.com/questions/38379553/using-printf-in-assembly-leads-to-an-empty-ouput)? When you use the exit system call.
    
- [Calling printf in x86_64 using GNU assembler](https://stackoverflow.com/questions/38335212/calling-printf-in-x86-64-using-gnu-assembler) calling convention, stack alignment, and working example. Related NASM-syntax version [Segfault while calling C function (printf) from Assembly](https://stackoverflow.com/questions/15575647/segfault-while-calling-c-function-printf-from-assembly)
    
    Canonical duplicate for scanf segfaulting on misaligned stack in modern Linux builds of glibc: [glibc scanf Segmentation faults when called from a function that doesn't align RSP](https://stackoverflow.com/questions/51070716/glibc-scanf-segmentation-faults-when-called-from-a-function-that-doesnt-align-r)
    
- Library functions modify registers / which registers do my functions need to save and restore? This is specified by the calling convention (part of the ABI) for the platform you're targeting. Search for those terms on this page. [What registers must be preserved by an x86 function?](https://stackoverflow.com/questions/9603003/what-registers-must-be-preserved-by-an-x86-function) is a decent canonical duplicate.
    
- mismatched push/pop: if the stack pointer isn't pointing at the return address when you `ret`, you crash.
    
- **How do I handle multi-digit numbers**? Linux, Windows, OS X, and DOS system calls for handling user input/output give you [ASCII](http://www.asciitable.com/) (or UTF-8) characters, or strings of characters. (Canonical Q&A for [single-digit failure to do `sub al, '0'`](https://stackoverflow.com/questions/62828237/why-is-my-assembly-output-in-letter-position-11-b)). You normally need to convert between strings and binary integers to do math on them, like the C functions `atoi` or `sprintf(buf, "%d", number)`. None of the common system-call APIs for major OSes that run on x86 provide these functions for you; only as libraries.
    
    [**string-to-integer** (32-bit NASM, algorithm works everywhere)](https://stackoverflow.com/questions/19309749/nasm-assembly-convert-input-to-integer). (multiply by 10 for place value) Also includes an int-to-string loop.
    
    **Printing integers**: [16-bit code to print 16 or 32-bit integers (in `dx:ax`)](https://stackoverflow.com/questions/45904075/displaying-numbers-with-dos) (1 digit at a time with MS-DOS `int 21h`, but could be adapted to store into a string or use a different output method.) Another [example for unsigned 16b numbers in DOS](https://stackoverflow.com/a/15621644) that calculates digits and stores them into a string in memory.
    
    2-digit decimal numbers (00-99), using BIOS `int 10h` for each digit: [Displaying Time in Assembly](https://stackoverflow.com/questions/37129794/displaying-time-in-assembly/37131263#37131263). (Just a special case of the general algorithm, not looping.)
    
    [NASM x86-64 function to convert and print a 32-bit unsigned integer](https://stackoverflow.com/questions/13166064/how-do-i-print-an-integer-in-assembly-level-programming-without-printf-from-the/46301894#46301894) (using a single Linux `write` system call on a buffer). Other answers on the same question show printing one character at a time. [AT&T version of the same function](https://stackoverflow.com/questions/45835456/printing-an-integer-as-a-string-with-att-syntax-with-linux-system-calls-instea/45851398#45851398), also showing a 5x faster version that uses a multiplicative inverse instead of `div` to divide by the compile-time constant 10.
    
    [How to convert a binary integer number to a hex string?](https://stackoverflow.com/questions/53823756/how-to-convert-a-number-to-hex) (32-bit NASM code. Scalar, SSE2, SSSE3, AVX512F, and AVX512VBMI versions.)
    
- [Loading pointers into registers vs. loading data into registers](https://stackoverflow.com/questions/43769467/x86-assembly-pointers): Make sure you understand the different between `mov reg, symbol` and `mov reg, [symbol]` (NASM syntax), or MASM syntax: `mov reg, OFFSET symbol` vs. `mov reg, symbol`. Many beginner questions are caused by mistakes in dereferencing addresses, or not dereferencing. This is the same as pointers in C.
    
- [Invalid combination of opcode and operands error](https://stackoverflow.com/questions/39958149/invalid-combination-of-opcode-and-operands-error-intel-x86) on `mov [msg], [ebp+8]`? You can't use two memory operands to one instruction. ([Why IA32 does not allow memory to memory mov?](https://stackoverflow.com/questions/11953352/why-ia32-does-not-allow-memory-to-memory-mov))
    
- [Bit-shifts and rotates need the count in `cl`](https://stackoverflow.com/questions/13425365/variable-bit-shift), not any other register, or as an immediate constant. `shl eax, ebx` is impossible, `shl eax, 2` is fine, and so is `shl eax, cl`
    
- [Call an absolute pointer in x86 machine code](https://stackoverflow.com/questions/19552158/call-an-absolute-pointer-in-x86-machine-code) or `jmp` to an absolute address. With examples in NASM and AT&T syntax.
    
- [Why do most x86-64 instructions zero the upper part of a 32 bit register?](https://stackoverflow.com/questions/11177137/why-do-most-x64-instructions-zero-the-upper-part-of-a-32-bit-register) In fact, _all_ instructions that write a 32bit register zero the upper 32 of the full 64bit register, so `mov eax, 1234` is more efficient than `mov rax, 1234`, but equivalent. This is not the case for writing to 8 and 16bit registers, like `al`/`ah`/`ax`, so you need `movzx` or `movsx` if the upper bits might hold garbage and you need to clear them (e.g. before using as part of a memory address).
    
- [Using LEA on values that aren't addresses / pointers?](https://stackoverflow.com/questions/46597055/using-lea-on-values-that-arent-addresses-pointers/46597375#46597375) It's just a shift-and-add ALU instruction that uses memory-operand syntax and machine encoding.
    
- [How to tell the length of an x86 instruction?](https://stackoverflow.com/q/4567903/417501) – with an overview over the x86 instruction encoding
    
- [Reversing a string](https://stackoverflow.com/questions/38824670/assembly-reverse-a-string/38827168#38827168)? This well-commented answer uses 16-bit ms-dos system calls to read the string, but the actual loop over the string works the same for 32 or 64-bit code.
    
- Indexing an array without scaling the index by the element width, resulting in overlapping loads or stores. [Declaring and indexing an integer array of qwords in assembly](https://stackoverflow.com/questions/58402110/making-an-integer-array-in-assembly) (x86-64 AT&T syntax)
    
- [boot loader works in QEMU but not on real hardware](https://stackoverflow.com/q/47277702/417501) – real computers some times expect the MBR to have a BPB (BIOS parameter block). If the BPB is missing or wrong, the BPB area in the MBR is overwritten with “correct” values, corrupting your boot loader.
    
- How do I do _X_ in assembly: usually the same way you would in another programming language, like C. Figure out what needs to happen to the data before you get bogged down in writing instructions to make it happen.
    

---

## How to get started / Debugging tools + guides

**Find a debugger that will let you single-step through your code, and display registers while that happens. This is essential**. We get many questions on here that are something like "why doesn't this code work" that could have been solved with a debugger.

**On Windows**, Visual Studio has a built-in debugger. See [Debugging ASM with Visual Studio - Register content will not display](https://stackoverflow.com/questions/46394685/debugging-asm-with-visual-studio-register-content-will-not-display). And see [Assembly programming - WinAsm vs Visual Studio 2017](https://stackoverflow.com/questions/52796300/assembly-programming-winasm-vs-visual-studio-2017) for a walk-through of setting up a Visual Studio project for a MASM 32-bit or 64-bit Hello World console application.

**On Linux**: A widely-available debugger is [gdb](https://www.gnu.org/software/gdb/). See [Debugging assembly](https://stackoverflow.com/questions/2091964/debugging-assembly) for some basic stuff about using it on Linux. Also [How can one see content of stack with GDB?](https://stackoverflow.com/questions/7848771/how-can-one-see-content-of-stack-with-gdb/37076050#37076050)

There are various GDB front-ends, including [GDBgui](https://www.gdbgui.com/). Also guides for vanilla GDB:

- [https://ncona.com/2019/12/debugging-assembly-with-gdb/](https://ncona.com/2019/12/debugging-assembly-with-gdb/)
- [http://beej.us/guide/bggdb/](http://beej.us/guide/bggdb/)

With [`layout asm` and `layout reg` enabled](https://sourceware.org/gdb/onlinedocs/gdb/TUI-Commands.html), GDB will highlight which registers changes since the last stop. **Use `stepi` to single-step by instructions.** Use `x` to examine memory at a given address (useful when trying to figure out why your code crashed while trying to read or write at a given address). In a binary without symbols (or even sections), you can use `starti` instead of `run` to stop before the first instruction. (On older GDB without `starti`, [you can use `b *0` as a hack to get gdb to stop on an error](https://stackoverflow.com/questions/10483544/stopping-at-the-first-machine-code-instruction-in-gdb/43722241#43722241).) Use `help x` or whatever for help on any command.

GNU tools have [an Intel-syntax mode that's similar to MASM](https://stackoverflow.com/a/44692497), which is nice to read but is rarely used for hand-written source (NASM/YASM is nice for that if you want to stick with open-source tools but avoid AT&T syntax):

- [`clang` or `gcc -Wall -O3 -masm=intel foo.c -fverbose-asm -S -o- | less`](https://stackoverflow.com/questions/38552116/how-to-remove-noise-from-gcc-clang-assembly-output) (affects inline-asm)
- GDB: `set disassembly-flavor intel` (can go in your `~/.gdbinit`)
- `objdump -drwC -Mintel`
- `perf report -Mintel`

Another key tool for debugging is **tracing system calls**. e.g. on a Unix system, `strace ./a.out` will show you the args and return values of all the system calls your code makes. It knows how to decode the args into symbolic values like `O_RDWR`, so it's much more convenient (and likely to catch brain-farts or wrong values for constants) than using a debugger to look at registers before/after an `int` or `syscall` instruction. Note that it doesn't work correctly on Linux `int 0x80` 32-bit ABI system calls in 64-bit processes: [What happens if you use the 32-bit int 0x80 Linux ABI in 64-bit code?](https://stackoverflow.com/questions/46087730/what-happens-if-you-use-the-32-bit-int-0x80-linux-abi-in-64-bit-code).

**To debug boot or kernel code**, boot it in Bochs, qemu, or maybe even DOSBox, or any other virtual machine / simulator / emulator. Use the debugging facilities of the VM to get _way_ better information than the usual "it locks up" you will experience with buggy privileged code.

[Bochs](https://bochs.sourceforge.io/) is generally recommended for debugging real-mode bootloaders, especially ones that switch to protected mode; Bochs's [built-in debugger](https://bochs.sourceforge.io/cgi-bin/topper.pl?name=New%20Bochs%20Documentation&url=https://bochs.sourceforge.io/doc/docbook/user/index.html) understands segmentation (unlike GDB), and can parse a GDT, IDT, and page tables to make sure you got the fields right.

**For DOS programs**, see [the x86-16 tag wiki](https://stackoverflow.com/tags/x86-16/info) for debuggers that run inside the guest, and thus can debug a specific DOS program maybe more easily than Bochs for the whole system.

---

REPL (Read Eval Print Loop) environments for typing an instruction and seeing what it does to register values. Maybe only useful for user-space, perhaps not osdev stuff.

- [https://github.com/tenderlove/asmrepl](https://github.com/tenderlove/asmrepl) in Ruby ([https://www.theregister.com/2021/11/30/asmrepl/](https://www.theregister.com/2021/11/30/asmrepl/))
- [https://github.com/yrp604/rappel](https://github.com/yrp604/rappel)
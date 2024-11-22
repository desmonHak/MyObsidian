https://en.wikipedia.org/wiki/Opaque_pointer

# Opaque pointer
From Wikipedia, the free encyclopedia

In [computer programming](https://en.wikipedia.org/wiki/Computer_programming "Computer programming"), an **opaque pointer** is a special case of an [opaque data type](https://en.wikipedia.org/wiki/Opaque_data_type "Opaque data type"), a [data type](https://en.wikipedia.org/wiki/Data_type "Data type") declared to be a [pointer](https://en.wikipedia.org/wiki/Pointer_(computer_science) "Pointer (computer science)") to a [record](https://en.wikipedia.org/wiki/Record_(computer_science) "Record (computer science)") or [data structure](https://en.wikipedia.org/wiki/Data_structure "Data structure") of some unspecified type.

Opaque pointers are present in several [programming languages](https://en.wikipedia.org/wiki/Programming_language "Programming language") including [Ada](https://en.wikipedia.org/wiki/Ada_(programming_language) "Ada (programming language)"), [C](https://en.wikipedia.org/wiki/C_(programming_language) "C (programming language)"), [C++](https://en.wikipedia.org/wiki/C%2B%2B "C++"), [D](https://en.wikipedia.org/wiki/D_(programming_language) "D (programming language)") and [Modula-2](https://en.wikipedia.org/wiki/Modula-2 "Modula-2").

If the language is [strongly typed](https://en.wikipedia.org/wiki/Strong_typing "Strong typing"), [programs](https://en.wikipedia.org/wiki/Computer_program "Computer program") and [procedures](https://en.wikipedia.org/wiki/Subroutine "Subroutine") that have no other information about an opaque pointer type _T_ can still declare [variables](https://en.wikipedia.org/wiki/Variable_(programming) "Variable (programming)"), [arrays](https://en.wikipedia.org/wiki/Array_data_structure "Array data structure"), and record fields of type _T_, assign values of that type, and compare those values for equality. However, they will not be able to [de-reference](https://en.wikipedia.org/wiki/Reference_(computer_science) "Reference (computer science)") such a pointer, and can only change the object's content by calling some procedure that has the missing information.

Opaque pointers are a way to hide the [implementation](https://en.wikipedia.org/wiki/Implementation_(computing) "Implementation (computing)") details of an [interface](https://en.wikipedia.org/wiki/Interface_(computer_science) "Interface (computer science)") from ordinary clients, so that the [implementation](https://en.wikipedia.org/wiki/Implementation_(computing) "Implementation (computing)") may be changed without the need to recompile the [modules](https://en.wikipedia.org/wiki/Module_(programming) "Module (programming)") using it. This benefits the programmer as well since a simple interface can be created, and most details can be hidden in another file.[[1]](https://en.wikipedia.org/wiki/Opaque_pointer#cite_note-1) This is important for providing [binary code compatibility](https://en.wikipedia.org/wiki/Binary_code_compatibility "Binary code compatibility") through different versions of a [shared library](https://en.wikipedia.org/wiki/Shared_library "Shared library"), for example.

This technique is described in _[Design Patterns](https://en.wikipedia.org/wiki/Design_Patterns "Design Patterns")_ as the [Bridge pattern](https://en.wikipedia.org/wiki/Bridge_pattern "Bridge pattern"). It is sometimes referred to as "**[handle](https://en.wikipedia.org/wiki/Handle_(computing) "Handle (computing)") classes**",[[2]](https://en.wikipedia.org/wiki/Opaque_pointer#cite_note-eckel20000-2) the "**Pimpl idiom**" (for "pointer to implementation idiom"),[[3]](https://en.wikipedia.org/wiki/Opaque_pointer#cite_note-3) "**Compiler firewall idiom**",[[4]](https://en.wikipedia.org/wiki/Opaque_pointer#cite_note-4) "**d-pointer"** or "**Cheshire Cat**", especially among the C++ community.[[2]](https://en.wikipedia.org/wiki/Opaque_pointer#cite_note-eckel20000-2)

## Examples

[[edit](https://en.wikipedia.org/w/index.php?title=Opaque_pointer&action=edit&section=1 "Edit section: Examples")]

### Ada
```ada
package Library_Interface is

   type Handle is limited private;

   -- Operations...

private
   type Hidden_Implementation;    -- Defined in the package body
   type Handle is access Hidden_Implementation;
end Library_Interface;
```

The type `Handle` is an opaque pointer to the real implementation, that is not defined in the specification. Note that the type is not only private (to forbid the clients from accessing the type directly, and only through the operations), but also limited (to avoid the copy of the data structure, and thus preventing dangling references).

```ada
package body Library_Interface is

   type Hidden_Implementation is record
      ...    -- The actual implementation can be anything
   end record;

   -- Definition of the operations...

end Library_Interface;
```

These types are sometimes called "**Taft types**"—named after [Tucker Taft](https://en.wikipedia.org/w/index.php?title=Tucker_Taft&action=edit&redlink=1 "Tucker Taft (page does not exist)"), the main designer of Ada 95—because they were introduced in the so-called Taft Amendment to Ada 83.[[5]](https://en.wikipedia.org/wiki/Opaque_pointer#cite_note-5)

### C
```c
/* obj.h */

struct obj;

/*
 * The compiler considers struct obj an incomplete type. Incomplete types
 * can be used in declarations.
 */

size_t obj_size(void);

void obj_setid(struct obj *, int);

int obj_getid(struct obj *);
```

```c
/* obj.c */

#include "obj.h"

struct obj {
    int id;
};

/*
 * The caller will handle allocation.
 * Provide the required information only
 */

size_t obj_size(void) {
    return sizeof(struct obj);
}

void obj_setid(struct obj *o, int i) {
    o->id = i;
}

int obj_getid(struct obj *o) {
    return o->id;
}
```

This example demonstrates a way to achieve the [information hiding](https://en.wikipedia.org/wiki/Information_hiding "Information hiding") ([encapsulation](https://en.wikipedia.org/wiki/Encapsulation_(computer_science) "Encapsulation (computer science)")) aspect of [object-oriented programming](https://en.wikipedia.org/wiki/Object-oriented_programming "Object-oriented programming") using the C language. If someone wanted to change the definition of `struct obj`, it would be unnecessary to recompile any other modules in the program that use the `obj.h` header file unless the [API](https://en.wikipedia.org/wiki/API "API") was also changed. Note that it may be desirable for the functions to check that the passed pointer is not `NULL`, but such checks have been omitted above for brevity.

### C++

```cpp
/* PublicClass.h */

#include <memory>

class PublicClass {
 public:
  PublicClass();                               // Constructor
  PublicClass(const PublicClass&);             // Copy constructor
  PublicClass(PublicClass&&);                  // Move constructor
  PublicClass& operator=(const PublicClass&);  // Copy assignment operator
  PublicClass& operator=(PublicClass&&);       // Move assignment operator
  ~PublicClass();                              // Destructor

  // Other operations...

 private:
  struct CheshireCat;                   // Not defined here
  std::unique_ptr<CheshireCat> d_ptr_;  // Opaque pointer
};
```

```cpp
/* PublicClass.cpp */

#include "PublicClass.h"

struct PublicClass::CheshireCat {
  int a;
  int b;
};

PublicClass::PublicClass()
    : d_ptr_(std::make_unique<CheshireCat>()) {
  // Do nothing.
}

PublicClass::PublicClass(const PublicClass& other)
    : d_ptr_(std::make_unique<CheshireCat>(*other.d_ptr_)) {
  // Do nothing.
}

PublicClass::PublicClass(PublicClass&& other) = default;

PublicClass& PublicClass::operator=(const PublicClass &other) {
  *d_ptr_ = *other.d_ptr_;
  return *this;
}

PublicClass& PublicClass::operator=(PublicClass&&) = default;

PublicClass::~PublicClass() = default;
```

The d-pointer pattern is one of the implementations of the _opaque pointer_. It is commonly used in C++ classes due to its advantages (noted below). A d-pointer is a private data member of the class that points to an instance of a structure. This method allows class declarations to omit private data members, except for the d-pointer itself.[[6]](https://en.wikipedia.org/wiki/Opaque_pointer#cite_note-6) As a result,

- more of the class implementation is hidden
- adding new data members to the private structure does not affect [binary compatibility](https://en.wikipedia.org/wiki/Binary_compatibility "Binary compatibility")
- the header file containing the class declaration only needs to include those files needed for the class interface, rather than for its implementation.

One side benefit is that compilations are faster because the header file changes less often. Note, possible disadvantage of d-pointer pattern is indirect member access through pointer (e.g., pointer to object in dynamic storage), which is sometimes slower than access to a plain, non-pointer member. The d-pointer is heavily used in the [Qt](https://en.wikipedia.org/wiki/Qt_(toolkit) "Qt (toolkit)")[[7]](https://en.wikipedia.org/wiki/Opaque_pointer#cite_note-7) and [KDE](https://en.wikipedia.org/wiki/KDE "KDE") libraries.

## See also
- [Application binary interface](https://en.wikipedia.org/wiki/Application_binary_interface "Application binary interface")
- [Handle (computing)](https://en.wikipedia.org/wiki/Handle_(computing) "Handle (computing)")
- [Programming idiom](https://en.wikipedia.org/wiki/Programming_idiom "Programming idiom")

## References
1. **[^](https://en.wikipedia.org/wiki/Opaque_pointer#cite_ref-1 "Jump up")** Chris McKillop. ["Programming Tools — Opaque Pointers"](http://community.qnx.com/sf/docman/do/downloadDocument/projects.toolchain/docman.root.articles/doc1150). QNX Software Systems. Retrieved 2019-01-16.
2. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Opaque_pointer#cite_ref-eckel20000_2-0) [_**b**_](https://en.wikipedia.org/wiki/Opaque_pointer#cite_ref-eckel20000_2-1) [Bruce Eckel](https://en.wikipedia.org/wiki/Bruce_Eckel "Bruce Eckel") (2000). ["Chapter 5: Hiding the Implementation"](http://web.mit.edu/merolish/ticpp/Chapter05.html). [_Thinking in C++, Volume 1: Introduction to Standard C++_](https://archive.org/details/thinkinginc00ecke) (2nd ed.). Prentice Hall. [ISBN](https://en.wikipedia.org/wiki/ISBN_(identifier) "ISBN (identifier)") [0-13-979809-9](https://en.wikipedia.org/wiki/Special:BookSources/0-13-979809-9 "Special:BookSources/0-13-979809-9").
3. **[^](https://en.wikipedia.org/wiki/Opaque_pointer#cite_ref-3 "Jump up")** Vladimir Batov (2008-01-25). ["Making Pimpl Easy"](http://ddj.com/cpp/205918714). _[Dr. Dobb's Journal](https://en.wikipedia.org/wiki/Dr._Dobb%27s_Journal "Dr. Dobb's Journal")_. Retrieved 2008-05-07.
4. **[^](https://en.wikipedia.org/wiki/Opaque_pointer#cite_ref-4 "Jump up")** Herb Sutter. _[The Joy of Pimpls (or, More About the Compiler-Firewall Idiom)](http://www.gotw.ca/publications/mill05.htm)_
5. **[^](https://en.wikipedia.org/wiki/Opaque_pointer#cite_ref-5 "Jump up")** Robert A. Duff (2002-07-29). ["Re: What's its name again?"](http://groups.google.es/group/comp.lang.ada/msg/a886bf7922727acf). [Newsgroup](https://en.wikipedia.org/wiki/Usenet_newsgroup "Usenet newsgroup"): [comp.lang.ada](news:comp.lang.ada). Retrieved 2007-10-11.
6. **[^](https://en.wikipedia.org/wiki/Opaque_pointer#cite_ref-6 "Jump up")** _[Using a d-Pointer](https://community.kde.org/Policies/Binary_Compatibility_Issues_With_C%2B%2B#Using_a_d-Pointer)_ — Why and how KDE implements opaque pointers
7. **[^](https://en.wikipedia.org/wiki/Opaque_pointer#cite_ref-7 "Jump up")** ["D-Pointer"](https://wiki.qt.io/D-Pointer). _Qt wiki_. Retrieved 23 Dec 2016.

## External links

[[edit](https://en.wikipedia.org/w/index.php?title=Opaque_pointer&action=edit&section=7 "Edit section: External links")]
The Wikibook _[Ada Programming](https://en.wikibooks.org/wiki/Ada_Programming "wikibooks:Ada Programming")_ has a page on the topic of: _**[Taft types](https://en.wikibooks.org/wiki/Ada_Programming/Tips#Full_declaration_of_a_type_can_be_deferred_to_the_unit's_body "wikibooks:Ada Programming/Tips")**_

The Wikibook _[C++ Programming](https://en.wikibooks.org/wiki/C%2B%2B_Programming "wikibooks:C++ Programming")_ has a page on the topic of: _**[the Pointer To Implementation (pImpl) idiom](https://en.wikibooks.org/wiki/C%2B%2B_Programming/Idioms#Pointer_To_Implementation_(pImpl) "wikibooks:C++ Programming/Idioms")**_
- [The Pimpl idiom](http://c2.com/cgi/wiki?PimplIdiom)
- [Compilation Firewalls](http://www.gotw.ca/gotw/024.htm) or [Compilation Firewalls](https://herbsutter.com/gotw/_100/)
- [The Fast Pimpl Idiom](http://www.gotw.ca/gotw/028.htm)
- [D-Pointers](https://community.kde.org/Policies/Binary_Compatibility_Issues_With_C%2B%2B#Using_a_d-Pointer) — KDE TechBase
- When you "XOR the pointer with a random number"[[1]](http://blogs.msdn.com/michael_howard/archive/2006/01/30/520200.aspx)[[2]](http://udrepper.livejournal.com/13393.html), the result is a "really opaque" pointer [[3]](http://www.iecc.com/gclist/GC-faq.html#GC,%20C,%20and%20C++).
- [Making Pimpl Easy](http://www.ddj.com/cpp/205918714), Vladimir Batov

| Parts,  <br>conventions | [Application binary interface](https://en.wikipedia.org/wiki/Application_binary_interface "Application binary interface") (ABI)<br>- [Alignment](https://en.wikipedia.org/wiki/Data_structure_alignment "Data structure alignment")<br>- [Calling convention](https://en.wikipedia.org/wiki/Calling_convention "Calling convention")<br>- [Call stack](https://en.wikipedia.org/wiki/Call_stack "Call stack")<br>- [Library](https://en.wikipedia.org/wiki/Library_(computing) "Library (computing)") <br>    - [static](https://en.wikipedia.org/wiki/Static_library "Static library")<br>- [Machine code](https://en.wikipedia.org/wiki/Machine_code "Machine code")<br>- [Memory segmentation](https://en.wikipedia.org/wiki/Memory_segmentation "Memory segmentation")<br>- [Name mangling](https://en.wikipedia.org/wiki/Name_mangling "Name mangling")<br>- [Object code](https://en.wikipedia.org/wiki/Object_code "Object code")<br>- Opaque pointer<br>- [Position-independent code](https://en.wikipedia.org/wiki/Position-independent_code "Position-independent code")<br>- [Relocation](https://en.wikipedia.org/wiki/Relocation_(computing) "Relocation (computing)")<br>- [System call](https://en.wikipedia.org/wiki/System_call "System call")<br>- [Virtual method table](https://en.wikipedia.org/wiki/Virtual_method_table "Virtual method table") |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Related topics          | - [Binary-code compatibility](https://en.wikipedia.org/wiki/Binary-code_compatibility "Binary-code compatibility")<br>- [Foreign function interface](https://en.wikipedia.org/wiki/Foreign_function_interface "Foreign function interface")<br>- [Language binding](https://en.wikipedia.org/wiki/Language_binding "Language binding")<br>- [Linker](https://en.wikipedia.org/wiki/Linker_(computing)) <br>    - [dynamic](https://en.wikipedia.org/wiki/Dynamic_linker "Dynamic linker")<br>- [Loader](https://en.wikipedia.org/wiki/Loader_(computing) "Loader (computing)")<br>- [Year 2038 problem](https://en.wikipedia.org/wiki/Year_2038_problem "Year 2038 problem")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |

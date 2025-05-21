https://stackoverflow.com/questions/2324658/how-to-determine-the-version-of-the-c-standard-used-by-the-compiler

- C++ pre-C++98: `__cplusplus` is `1`.
- C++98: `__cplusplus` is `199711L`.
- C++98 + TR1: This reads as C++98 and there is no way to check that I know of.
- C++11: `__cplusplus` is `201103L`.
- C++14: `__cplusplus` is `201402L`.
- C++17: `__cplusplus` is `201703L`.
- C++20: `__cplusplus` is `202002L`.
- C++23: `__cplusplus` is `202302L`.


```cpp
#if ((defined(_MSVC_LANG) && _MSVC_LANG >= 201703L) || __cplusplus >= 201703L)
     //C++17 specific stuff here
#endif
```

```cpp
/*Define Microsoft Visual C++ .NET (32-bit) compiler */
#if (defined(_M_IX86) && defined(_MSC_VER) && (_MSC_VER >= 1300)
     ...
#endif

/*Define Borland 5.0 C++ (16-bit) compiler */
#if defined(__BORLANDC__) && !defined(__WIN32__)
     ...
#endif
```

```cpp
#include <iostream>
#include <sstream>

/**
 * Get Human Readable C++ Version
 * @return std::string
 */
std::string c_plus_plus_version() {
    std::ostringstream version;

    switch (__cplusplus) {
        case 202101L:
            version << "C++23";
            break;
        case 202002L:
            version << "C++20";
            break;
        case 201703L:
            version << "C++17";
            break;
        case 201402L:
            version << "C++14";
            break;
        case 201103L:
            version << "C++11";
            break;
        case 199711L:
            version << "C++98";
            break;
        default:
            version << "pre-standard C++: " << __cplusplus;
            break;
    }

    return version.str();
}


int main() {
    std::cout << c_plus_plus_version() << std::endl;
    return 0;
}


```
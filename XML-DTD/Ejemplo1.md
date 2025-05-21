```xml
<?xml version="1.0" encoding="UTF-8"?>  
<!DOCTYPE note SYSTEM "Note.dtd">  
<note>  
	<to>Tove</to>  
	<from>Jani</from>  
	<heading>Reminder</heading>  
	<body>Don't forget me this weekend!</body>  
</note>
```

```dtd
<!DOCTYPE note  
[  
	<!ELEMENT note (to,from,heading,body)>  
	<!ELEMENT to (#PCDATA)>  
	<!ELEMENT from (#PCDATA)>  
	<!ELEMENT heading (#PCDATA)>  
	<!ELEMENT body (#PCDATA)>  
]>
```

---

```xml
<?xml version="1.0" encoding="UTF-8"?>  
<!DOCTYPE note SYSTEM "Note.dtd">  
<note>  
	<to>Tove</to>  
	<from>Jani</from>  
	<heading>Reminder</heading>  
	<body>Don't forget me this weekend!</body>  
	<footer>&writer;&nbsp;&copyright;</footer>  
</note>
```

```dtd
<?xml version="1.0" encoding="UTF-8"?>  
  
<!DOCTYPE note [  
	<!ENTITY nbsp "&#xA0;">  
	<!ENTITY writer "Writer: Donald Duck.">  
	<!ENTITY copyright "Copyright: W3Schools.">  
]>  

```
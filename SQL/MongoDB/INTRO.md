- MongoDB:  [Download MongoDB Community Server | MongoDB]([Download MongoDB Community Server | MongoDB](https://www.mongodb.com/try/download/community))
- [MongoDB Shell]([MongoDB Shell Download | MongoDB](https://www.mongodb.com/try/download/shell)): terminal
- (opc) [MongoDB Atlas]( https://www.mongodb.com/es/cloud/atlas/register ) (cloud):
- [MongoDB Tools](https://www.mongodb.com/try/download/database- tools?tck=docs_databasetools)

# importar datos
```js
mongoimport
	--db=rcdDB
	--collection=rcd
	--file=ruta/archivo.json
	--jsonArray
```

crear o usar una base de datos "blog":
```js
use blog
```

crear una colección posts
```js
db.createCollections("posts")
```

ver bases de datos:
```js
show databases
```

![[Pasted image 20250509094131.png]]

Insertar Datos(one - uno, many - muchos).
```js
// insertar un conjunto de datos:
db.posts.insertOne({ 
	title: "Post Title 1", 
	body: "Body of post.", 
	category: "News", 
	likes: 1, 
	tags: ["news", "events"], 
	date: Date() }
) 

// insertar varios conjuntos de datos
db.posts.insertMany(
	[ 
		{ 
			title: "Post Title 2", 
			body: "Body of post.",
			category: "Event", 
			likes: 2, 
			tags: ["news", "events"], 
			date: Date() 
		}, { 
			title: "Post Title 3", 
			body: "Body of post.", 
			category: "Technology", 
			likes: 3, 
			tags: ["news", "events"], 
			date: Date() 
		}, 
		{ 
			title: "Post Title 4", 
			body: "Body of post.", 
			category: "Event", 
			likes: 4, 
			tags: ["news", "events"], 
			date: Date() 
		} 
	]
)
```

![[Pasted image 20250509094443.png]]

# Buscar datos

```js
db.posts.find() 
db.posts.findOne() 
db.posts.find( {category: "News"} ) 
db.posts.find({}, {title: 1, date: 1}) 
db.posts.find({}, {_id: 0, title: 1, date: 1}) db.posts.find({}, {category: 0})
```

# Update Document
```js
db.posts.find( 
	{ title: "Post Title 1" } 
) 
db.posts.updateOne( 
	{ title: "Post Title 1" }, 
	{ $set: { likes: 2 } } 
) 

// Insert if not found (upsert) 

db.posts.updateOne( 
	{ title: "Post Title 5" }, 
	{ $set: { 
		title: "Post Title 5", 
		body: "Body of post.", 
		category: "Event", 
		likes: 5, 
		tags: ["news", "events"], 
		date: Date() } 
	}, { 
		upsert: true 
	} 
) 
db.posts.updateMany({}, { 
	$inc: { 
		likes: 1 
	} 
})
```
const express = require('express')
const app = express()

app.get('/', function (req, res) {
  res.send('Hello world! This is Gopi krishna')
})

app.listen(3000)

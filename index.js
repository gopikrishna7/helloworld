const express = require('express')
const app = express()

app.get('/', function (req, res) {
  res.send('Hello world! I am krishna')
})

app.listen(3000)

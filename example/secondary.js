'use strict'

exports.handler = function (event, context, callback) {
  var response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/html; charset=utf-8',
    },
    body: '<ol><li>hi</li><li>there</li></ol>',
  }
  callback(null, response)
}

"use strict";
var fs        = require("fs");
var path      = require("path");
var Sequelize = require("sequelize");
var env       = process.env.NODE_ENV || "development";
var config    = require(__dirname + '/../../../config/db.json')[env];

// Override config with environment variables in production
if (env === 'production') {
  config = {
    username: process.env.MYSQL_USER || config.username,
    password: process.env.MYSQL_PASSWORD || config.password,
    database: process.env.MYSQL_DATABASE || config.database,
    host: process.env.MYSQL_HOST || config.host,
    port: process.env.MYSQL_PORT || config.port || 3306,
    dialect: config.dialect
  };
}

var sequelize = new Sequelize(config.database, config.username, config.password, config);
var db        = {};

fs
  .readdirSync(__dirname)
  .filter(function(file) {
    return (file.indexOf(".") !== 0)
      && (file !== "index.js");
  })
  .forEach(function(file) {
    var model = sequelize["import"](path.join(__dirname, file));
    db[model.name] = model;
  });

// Link models according associations
//
Object.keys(db).forEach(function(modelName) {
  if ("associate" in db[modelName]) {
    db[modelName].associate(db);
  }
});

// Add scopes
//
Object.keys(db).forEach(function(modelName) {
  if ('loadScope' in db[modelName]) {
    db[modelName].loadScope(db);
  }
});

// Link models based on associations that are based on scopes
//
Object.keys(db).forEach(function(modelName) {
  if ('scopeAssociate' in db[modelName]) {
    db[modelName].scopeAssociate(db);
  }
});

db.sequelize = sequelize;
db.Sequelize = Sequelize;
module.exports = db;

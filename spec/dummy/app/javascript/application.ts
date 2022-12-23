// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import { start } from "./../../../../src/index";
import { application } from "./controllers/application";
import "./controllers";

start({ application });

import "@hotwired/turbo-rails";
import { start } from "../../../../src/index";
import { application } from "./controllers/application";
import "./controllers";

application.debug = false;
window.Stimulus = application;

start({ application });

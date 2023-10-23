import "@hotwired/turbo-rails";
import { start } from "../../../../src/index";
import { application } from "./controllers/application";
import "./controllers";

start({ application });

ui.consent.enableGoogleTagManager("GOOGLE_TAG_MANAGER_ID");

// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import MultiStepController from "./multi_step_controller"
application.register("multi-step", MultiStepController)

// import TravelMapController from "./travel_map_controller"
// application.register("map", MapController)



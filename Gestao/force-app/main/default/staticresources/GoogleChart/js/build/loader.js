
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var exports = {};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createChartWrapper = exports.dataTable = exports.load = void 0;
/**
 * @license
 * Copyright 2014-2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * Promise that resolves when the gviz loader script is loaded, which
 * provides access to the Google Charts loading API.
 */
const loaderPromise = new Promise((resolve, reject) => {
    // Resolve immediately if the loader script has been added already and
    // `google.charts.load` is available. Adding the loader script twice throws
    // an error.
    
    if (typeof google !== 'undefined' && google.charts &&
        typeof google.charts.load === 'function') {
        resolve();
    }
    else {
        
        require.ensure(['./file-loader.js'], require => {
            let scriptLoader = require('./file-loader.js');
            scriptLoader.addEventListener('load', resolve);
            scriptLoader.addEventListener('error', reject);
         });
        
        
        // Try to find existing loader script.
        
        
    }
});

/**
 * Loads Google Charts API with the selected settings or using defaults.
 *
 * The following settings are available:
 * - version: which version of library to load, default: 'current',
 * - packages: which chart packages to load, default: ['corechart'],
 * - language: what language to load library in, default: `lang` attribute on
 *   `<html>` or 'en' if not specified,
 * - mapsApiKey: key to use for maps API.
 */
function load(settings = {}) {
    return __awaiter(this, void 0, void 0, function* () {
        yield loaderPromise;
        const { version = 'current', packages = ['corechart'], language = document.documentElement.lang || 'en', mapsApiKey, } = settings;
        return google.charts.load(version, {
            'packages': packages,
            'language': language,
            'mapsApiKey': mapsApiKey,
        });
    });
}
exports.load = load;
/**
 * Creates a DataTable object for use with a chart.
 *
 * Multiple different argument types are supported. This is because the
 * result of loading the JSON data URL is fed into this function for
 * DataTable construction and its format is unknown.
 *
 * The data argument can be one of a few options:
 *
 * - null/undefined: An empty DataTable is created. Columns must be added
 * - !DataTable: The object is simply returned
 * - {{cols: !Array, rows: !Array}}: A DataTable in object format
 * - {{cols: !Array}}: A DataTable in object format without rows
 * - !Array<!Array>: A DataTable in 2D array format
 *
 * Un-supported types:
 *
 * - Empty !Array<!Array>: (e.g. `[]`) While technically a valid data
 *   format, this is rejected as charts will not render empty DataTables.
 *   DataTables must at least have columns specified. An empty array is most
 *   likely due to a bug or bad data. If one wants an empty DataTable, pass
 *   no arguments.
 * - Anything else
 *
 * See <a
 * href="https://developers.google.com/chart/interactive/docs/reference#datatable-class">the
 * docs</a> for more details.
 *
 * @param data The data which we should use to construct new DataTable object
 */
function dataTable(data) {
    return __awaiter(this, void 0, void 0, function* () {
        // Ensure that `google.visualization` namespace is added to the document.
        yield load();
        if (data == null) {
            return new google.visualization.DataTable();
        }
        else if (data.getNumberOfRows) {
            // Data is already a DataTable
            return data;
        }
        else if (data.cols) { // data.rows may also be specified
            // Data is in the form of object DataTable structure
            return new google.visualization.DataTable(data);
        }
        else if (data.length > 0) {
            // Data is in the form of a two dimensional array.
            return google.visualization.arrayToDataTable(data);
        }
        else if (data.length === 0) {
            // Chart data was empty.
            // We throw instead of creating an empty DataTable because most
            // (if not all) charts will render a sticky error in this situation.
            throw new Error('Data was empty.');
        }
        throw new Error('Data format was not recognized.');
    });
}
exports.dataTable = dataTable;
/**
 * Creates new `ChartWrapper`.
 * @param container Element in which the chart will be drawn
 */
function createChartWrapper(container) {
    return __awaiter(this, void 0, void 0, function* () {
        // Ensure that `google.visualization` namespace is added to the document.
        yield load();
        // Typings suggest that `chartType` is required in `ChartSpecs`, but it works
        // without it.
        return new google.visualization.ChartWrapper({ 'container': container });
    });
}
exports.createChartWrapper = createChartWrapper;
//# sourceMappingURL=loader.js.map
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibG9hZGVyLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vbG9hZGVyLmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7Ozs7Ozs7Ozs7OztBQUFBOzs7Ozs7Ozs7Ozs7Ozs7R0FlRztBQUNIOzs7R0FHRztBQUNILE1BQU0sYUFBYSxHQUFHLElBQUksT0FBTyxDQUFDLENBQUMsT0FBTyxFQUFFLE1BQU0sRUFBRSxFQUFFO0lBQ2xELHNFQUFzRTtJQUN0RSwyRUFBMkU7SUFDM0UsWUFBWTtJQUNaLElBQUksT0FBTyxNQUFNLEtBQUssV0FBVyxJQUFJLE1BQU0sQ0FBQyxNQUFNO1FBQzlDLE9BQU8sTUFBTSxDQUFDLE1BQU0sQ0FBQyxJQUFJLEtBQUssVUFBVSxFQUFFO1FBQzFDLE9BQU8sRUFBRSxDQUFDO0tBQ2I7U0FDSTtRQUNELHNDQUFzQztRQUN0QyxJQUFJLFlBQVksR0FBRyxRQUFRLENBQUMsYUFBYSxDQUFDLHdEQUF3RCxDQUFDLENBQUM7UUFDcEcsSUFBSSxDQUFDLFlBQVksRUFBRTtZQUNmLHdDQUF3QztZQUN4QyxZQUFZLEdBQUcsUUFBUSxDQUFDLGFBQWEsQ0FBQyxRQUFRLENBQUMsQ0FBQztZQUNoRCwrREFBK0Q7WUFDL0QsWUFBWSxDQUFDLEdBQUcsR0FBRywwQ0FBMEMsQ0FBQztZQUM5RCxRQUFRLENBQUMsSUFBSSxDQUFDLFdBQVcsQ0FBQyxZQUFZLENBQUMsQ0FBQztTQUMzQztRQUNELFlBQVksQ0FBQyxnQkFBZ0IsQ0FBQyxNQUFNLEVBQUUsT0FBTyxDQUFDLENBQUM7UUFDL0MsWUFBWSxDQUFDLGdCQUFnQixDQUFDLE9BQU8sRUFBRSxNQUFNLENBQUMsQ0FBQztLQUNsRDtBQUNMLENBQUMsQ0FBQyxDQUFDO0FBQ0g7Ozs7Ozs7OztHQVNHO0FBQ0gsU0FBc0IsSUFBSSxDQUFDLFFBQVEsR0FBRyxFQUFFOztRQUNwQyxNQUFNLGFBQWEsQ0FBQztRQUNwQixNQUFNLEVBQUUsT0FBTyxHQUFHLFNBQVMsRUFBRSxRQUFRLEdBQUcsQ0FBQyxXQUFXLENBQUMsRUFBRSxRQUFRLEdBQUcsUUFBUSxDQUFDLGVBQWUsQ0FBQyxJQUFJLElBQUksSUFBSSxFQUFFLFVBQVUsR0FBRyxHQUFHLFFBQVEsQ0FBQztRQUNsSSxPQUFPLE1BQU0sQ0FBQyxNQUFNLENBQUMsSUFBSSxDQUFDLE9BQU8sRUFBRTtZQUMvQixVQUFVLEVBQUUsUUFBUTtZQUNwQixVQUFVLEVBQUUsUUFBUTtZQUNwQixZQUFZLEVBQUUsVUFBVTtTQUMzQixDQUFDLENBQUM7SUFDUCxDQUFDO0NBQUE7QUFSRCxvQkFRQztBQUNEOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztHQTZCRztBQUNILFNBQXNCLFNBQVMsQ0FBQyxJQUFJOztRQUNoQyx5RUFBeUU7UUFDekUsTUFBTSxJQUFJLEVBQUUsQ0FBQztRQUNiLElBQUksSUFBSSxJQUFJLElBQUksRUFBRTtZQUNkLE9BQU8sSUFBSSxNQUFNLENBQUMsYUFBYSxDQUFDLFNBQVMsRUFBRSxDQUFDO1NBQy9DO2FBQ0ksSUFBSSxJQUFJLENBQUMsZUFBZSxFQUFFO1lBQzNCLDhCQUE4QjtZQUM5QixPQUFPLElBQUksQ0FBQztTQUNmO2FBQ0ksSUFBSSxJQUFJLENBQUMsSUFBSSxFQUFFLEVBQUUsa0NBQWtDO1lBQ3BELG9EQUFvRDtZQUNwRCxPQUFPLElBQUksTUFBTSxDQUFDLGFBQWEsQ0FBQyxTQUFTLENBQUMsSUFBSSxDQUFDLENBQUM7U0FDbkQ7YUFDSSxJQUFJLElBQUksQ0FBQyxNQUFNLEdBQUcsQ0FBQyxFQUFFO1lBQ3RCLGtEQUFrRDtZQUNsRCxPQUFPLE1BQU0sQ0FBQyxhQUFhLENBQUMsZ0JBQWdCLENBQUMsSUFBSSxDQUFDLENBQUM7U0FDdEQ7YUFDSSxJQUFJLElBQUksQ0FBQyxNQUFNLEtBQUssQ0FBQyxFQUFFO1lBQ3hCLHdCQUF3QjtZQUN4QiwrREFBK0Q7WUFDL0Qsb0VBQW9FO1lBQ3BFLE1BQU0sSUFBSSxLQUFLLENBQUMsaUJBQWlCLENBQUMsQ0FBQztTQUN0QztRQUNELE1BQU0sSUFBSSxLQUFLLENBQUMsaUNBQWlDLENBQUMsQ0FBQztJQUN2RCxDQUFDO0NBQUE7QUF6QkQsOEJBeUJDO0FBQ0Q7OztHQUdHO0FBQ0gsU0FBc0Isa0JBQWtCLENBQUMsU0FBUzs7UUFDOUMseUVBQXlFO1FBQ3pFLE1BQU0sSUFBSSxFQUFFLENBQUM7UUFDYiw2RUFBNkU7UUFDN0UsY0FBYztRQUNkLE9BQU8sSUFBSSxNQUFNLENBQUMsYUFBYSxDQUFDLFlBQVksQ0FBQyxFQUFFLFdBQVcsRUFBRSxTQUFTLEVBQUUsQ0FBQyxDQUFDO0lBQzdFLENBQUM7Q0FBQTtBQU5ELGdEQU1DO0FBQ0Qsa0NBQWtDIn0=
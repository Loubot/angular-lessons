exports.config = {
    allScriptsTimeout: 11000,
 
    specs: [
        'spec/javascripts/controllers/register_controller_spec.js'
    ],
 
    capabilities: {
        'browserName': 'chrome'
    },
 
    seleniumAddress: 'http://localhost:4444/wd/hub',
 
    framework: 'jasmine',
 
    jasmineNodeOpts: {
        defaultTimeoutInterval: 30000
    }
};
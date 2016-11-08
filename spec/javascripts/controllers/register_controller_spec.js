describe('Protractor Demo App', function() {
  it('should hit welcome', function() {
    browser.get('http://localhost:3000/');
    expect(browser.getTitle()).toEqual('LYL');
  });

  it('should press the menu button', function(){
    element(by.css('.md-fab')).click();
    expect($('md-fab-speed-dial').isDisplayed()).toBe(true);
  });

  it('should not be logged in', function(){
    x = element.all(by.css('.md-default-theme')).first();
    console.log(x);
    element.all(by.css('.md-default-theme')).then(function(elements) {
      
  });
    
  });
});

var cursor = new vCursor();
cursor.focusElement($$('input[name=email]').getLast());
cursor.typewriteText($$('input[name=email]').getLast(), "xxx", 100);
cursor.focusElement($$('input[name=password]').getLast());
cursor.typewriteText($$('input[name=password]').getLast(), "xxx", 100);
cursor.focusElement($$('button').getLast()); 
cursor.submitForm($$('form').getLast());
cursor.begin();

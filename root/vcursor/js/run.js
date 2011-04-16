var cursor = new vCursor();
cursor.focusElement($('textbox'));
cursor.typewriteText($('textbox'), "hallo Welt", 100);
cursor.focusElement($('textbox2'));
cursor.typewriteText($('textbox2'), "hallo Welt", 100);
cursor.clickElement($('clickme'));
cursor.begin();

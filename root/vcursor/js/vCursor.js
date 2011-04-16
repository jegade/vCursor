var vCursor = new Class({

    initialize: function(calls) {

        var these = this;
        
        this.cursor = new Element('span', {
            'class': 'vcursor'
        });
        
        this.cursor.set('move', {
            duration: 1000,
            link: 'ignore',
            transition:'sine:in',
            onComplete: function() {   these.next();        }
        });
    
        this.scroller = new Fx.Scroll(window, { duration: 1800, transition:'sine:in' });
               
        this.queue = new Chain();
       
        this.cursor.inject(document.body);
            
    },

    // Begin Action
    begin: function() {
         
      this.queue.callChain();  
    },
    
    next: function(delayer) {
        var these = this;
        (function(){these.queue.callChain()}).delay(delayer);  
    },
    
    // Move to position;
    moveTo: function(element, speed) {

        var these = this;
        this.queue.chain(function() { 
                these.scroller.toElement(element); 
                these.cursor.move({ 
                relativeTo: element,   
                position: 'upperLeft',
                edge: 'upperLeft',
                offset: {x: 10, y: 10}
            }); 
        });
    },

    // Highlight Element
    highLight: function(element) {
      
        var these = this;
        this.queue.chain(function() { element.highlight(); these.next() }); 
    },
    
    // Click an Element - follow the URL if
    clickElement: function(element) {

        // Queue Move
        this.moveTo(element);
        
        // Queu 
        this.highLight( element );
        
        this.queue.chain(function() {
        
        if ( element.get('href') ) {
         
            (function() { window.location.href = element.get('href') }).delay(500);
            
        } else {
            
            element.fireEvent('click');            
        }
        
        });

    },

    submitForm: function(form) {

        var these = this;
        this.queue.chain(function() { form.submit(); });
    },

    focusElement: function(element) {

        var these = this;
        this.moveTo(element);
        this.highLight(element);
        this.queue.chain(function() { element.focus(); these.next() });
    },

    typewriteText: function(element, stext, duration) {

        
        var these = this;
        this.queue.chain( function() { element.set('value',''); these.next() });  
        
        stext.split("").each( function(chara) {
            these.queue.chain( function() { element.set('value', element.get('value') + chara  ); these.next(duration)});
        });
    }
 })

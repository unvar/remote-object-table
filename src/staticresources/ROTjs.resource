function defineROT(root) {
  root.ROT = (function() {

    // util
    function addEvent(evnt, elem, func) {
       if (elem.addEventListener) {  // W3C DOM
          elem.addEventListener(evnt,func,false);
       } else if (elem.attachEvent) { // IE DOM
          elem.attachEvent("on"+evnt, func);
       } else { // No much to do
          elem[evnt] = func;
       }
    };

    // define a Table class that encapsulates our functionality
    var Table = function(o) {
      // setup options with defaults
      this.o = o;
      this.o.offset = o.offset || 1;

      // obj
      this.obj = new o.ns[o.name];

      // dom
      this.dom = {
        more: document.getElementById(o.moreId),
        tmpl: Handlebars.compile(document.getElementById(o.tmplId).innerHTML.trim()),
        tbody: document.getElementById(o.tbodyId),
      };

      // bind events
      var self = this;
      addEvent('click', this.dom.more, function() {
        self.more.call(self);
      });

      // first load
      this.more();
    };

    Table.prototype.more = function() {
      // disable more
      this.dom.more.disabled = true;

      // retrive data and update
      var self = this;
      this.obj.retrieve({
        limit: this.o.limit,
        offset: this.o.offset
      }, function(err, recs) {
        if (err) {
          // TODO: Better error handling
          console.log(err.message);
        } else {
          // render the rows
          var tbodyFrag = document.createDocumentFragment();
          for(var i = 0, l = recs.length; i < l; i++) {
            var row = document.createElement('tr');
            row.innerHTML = self.dom.tmpl(recs[i]._props);
            tbodyFrag.appendChild(row);
          }
          self.dom.tbody.appendChild(tbodyFrag);

          self.o.offset += recs.length;
        }

        // re-enable more
        self.dom.more.disabled = false;
      })
    };

    // a reference to all tables
    var tables = {};

    return {
      init: function(o) {
        // init the table
        tables[o.tableId] = new Table(o);            
      }
    };
  })();
}

function registerHandlebarsHelpers() {
  // register helpers for Handlebars
  // TODO: Locale support
  Handlebars.registerHelper('date', function(date) {
    return moment(date).format('L')
  });

  Handlebars.registerHelper('datetime', function(date) {
    return moment(date).format('LLL')
  });

  Handlebars.registerHelper('time', function(date) {
    return moment(date).format('h:mm:ss a')
  });
}

if (!window.ROT) {
  defineROT(window);
  registerHandlebarsHelpers();
}
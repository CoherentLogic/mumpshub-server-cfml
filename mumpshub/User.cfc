
component accessors="true" access="public" {

    public component function init(struct options) 
    {
        this.written = false;

        if(isDefined("options")) {
            this.account = options.account;
        }
        else {
            this.account = {
                username: "",
                passwordHash: "",
                name: {
                    first: "",
                    middle: "",
                    last: ""
                }
            };
        }
    }

    public component function open(required string username)
    {
        var global = new lib.cfmumps.Global("mumpshub", ["users", username]);

        if(global.defined().defined) {
            this.account = global.getObject();
        }

        global.close();

        this.written = true;

        return this;
    }

    public component function save()
    {
        if(this.account.username != "") {
            var global = new lib.cfmumps.Global("mumpshub", ["users", this.account.username]);

            global.setObject(this.account);

            global.close();
        }

        this.written = true;

        return this;
    }

    public component function setPassword(required string password)
    {
        this.account.passwordHash = hash(arguments.password, "SHA-256");
        this.save();

        return this;
    }

    public void function delete()
    {
        var global = new lib.cfmumps.Global("mumpshub", ["users", this.account.username]);

        if(global.defined().defined) {
            global.delete();
            return false;
        }

        global.close();

        this.written = false;

        return true;
    }

    public boolean function authenticate(required string passwordHash)
    {

    }

}
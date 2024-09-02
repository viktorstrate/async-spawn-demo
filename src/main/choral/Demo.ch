package demo;

import java.util.concurrent.CompletableFuture;
import java.util.function.Consumer;

import choral.channels.AsyncChannel;
import choral.runtime.Token;

class Demo@(Client, Server) {
    AsyncChannel@( Client, Server )< String > ch;

    public Demo(AsyncChannel@( Client, Server )< String > ch) {
        this.ch = ch;
    }

    public void start(Token@Client tok_c, Token@Server tok_s) {
        System@Client.out.println("Client started"@Client);
        System@Server.out.println("Server started"@Server);

        String@Client msg = "Hiya!"@Client;

        CompletableFuture@Server<String> foo = null@Server;
        if (msg == "Hiya!"@Client) {
            ch.<HelloChoice>select( HelloChoice@Client.YES );
            foo = ch.<String>com( msg, 1@Client, tok_c, 1@Server, tok_s );
        }
        else {
            ch.<HelloChoice>select( HelloChoice@Client.NO );
            foo = ch.<String>com( "bogus"@Client, 2@Client, tok_c, 2@Server, tok_s );
        }

        Consumer@Server<String> onFoo = new OnFoo@Server();
        foo.thenAccept(onFoo);

        System@Client.out.println("Client ended"@Client);
        System@Server.out.println("Server ended"@Server);
    }
}
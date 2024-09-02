package demo;

import java.lang.Runnable;
import java.util.List;
import java.util.concurrent.Executors;

import choral.runtime.AsyncChannelImpl;
import choral.runtime.Token;
import choral.runtime.LocalChannel.LocalChannelImpl;
import choral.runtime.Media.MessageQueue;

public class Main {
    public static void main(String[] args) {
        System.out.println("Hello world");

        LocalChannelImpl localCh = new LocalChannelImpl(new MessageQueue(), new MessageQueue());
        AsyncChannelImpl<String> ch = new AsyncChannelImpl<>(Executors.newSingleThreadScheduledExecutor(), localCh);

        Demo_Server server = new Demo_Server(ch);
        Demo_Client client = new Demo_Client(ch);

        List.<Runnable>of(() -> server.start(new Token()), () -> client.start(new Token()))
                .parallelStream().forEach(Runnable::run);

        System.out.println("Done");
    }
}

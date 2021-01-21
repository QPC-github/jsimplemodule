import org.omnetpp.simkernel.*;

/**
 *
 */
class Node extends JSimpleModule {

    protected void initialize() {
        scheduleAt(1, new cMessage("timer"));
    }

    protected void handleMessage(cMessage msg) {
        if (msg.getClassName().equals("IPHeader")) {
            ev.println("source=" + msg.getField("source"));
            ev.println("destination=" + msg.getField("destination"));
            ev.println("extrainfo=" + msg.getField("extrainfo"));
        }
        msg.delete();

        cMessage pk = cMessage.cast(Simkernel.createOne("IPHeader"));
        pk.setField("source", "1");
        pk.setField("destination", "2");
        pk.setField("extrainfo", "bla");
        send(pk, "out");
    }
};





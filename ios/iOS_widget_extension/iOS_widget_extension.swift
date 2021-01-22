import WidgetKit
import SwiftUI
import Intents

struct FlutterData: Decodable, Hashable {
    let text: String
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let flutterData: FlutterData?
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), flutterData: FlutterData(text: "Hello from Flutter"))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), flutterData: FlutterData(text: "Hello from Flutter"))
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let sharedDefaults = UserDefaults.init(suiteName: "group.ios.widget.kit")
        var flutterData: FlutterData? = nil

        if(sharedDefaults != nil) {
            do {
              let shared = sharedDefaults?.string(forKey: "widgetData")
              if(shared != nil){
                let decoder = JSONDecoder()
                flutterData = try decoder.decode(FlutterData.self, from: shared!.data(using: .utf8)!)
              }
            } catch {
              print(error)
            }
        }

        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, flutterData: flutterData)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct FlutterWidgetEntryView : View {
    var entry: Provider.Entry
    var title: String
    
    @State var isChecked:Bool = true
    func toggle(){isChecked = !isChecked}

    private var FlutterDataView: some View {
        ZStack {
            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    Text(title)
                        .font(.title)
                }
                Button(action: toggle){
                    HStack{
                        Image(systemName: isChecked ? "checkmark.circle": "circle")
                        Text(title)
                        Spacer()
                    }
                }.padding(.leading, 15)
                Button(action: toggle){
                    HStack{
                        Image(systemName: isChecked ? "checkmark.circle": "circle")
                        Text(title)
                        Spacer()
                    }
                }.padding(.leading, 15)
                Button(action: toggle){
                    HStack{
                        Image(systemName: isChecked ? "checkmark.circle": "circle")
                        Text(title)
                        Spacer()
                    }
                }.padding(.leading, 15)
            }
        }
    }

    private var NoDataView: some View {
        // 内包する子Viewを重ねて配置するStack Viewです。
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                HStack {
                    Text(entry.flutterData!.text)
                        .font(.subheadline)
                        .frame(width: 300, height: 100)
                    Spacer()
                }
                
                HStack {
                    Text("Todo list Todo list")
                        .font(.caption)
                        .frame(width: 300, height: 100)
                    Spacer()
                }
                HStack {
                    Text("Todo list")
                        .font(.caption)
                        .frame(width: 300, height: 100)
                    Spacer()
                }
            }
        }
    }
    
    var body: some View {
        FlutterDataView
    }
    
//    var body: some View {
//      if(entry.flutterData == nil) {
//        NoDataView
//      } else {
//        FlutterDataView
//      }
//    }
}


@main
struct FlutterWidget: Widget {
    let kind: String = "FlutterWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FlutterWidgetEntryView(entry: entry, title:"Todo list")
        }
        .configurationDisplayName("Flutter Example Widget")
        .description("This is an example widget which communicates with a Flutter App.")
    }
}

struct FlutterWidget_Previews: PreviewProvider {
    static var previews: some View {
        FlutterWidgetEntryView(entry: SimpleEntry(date: Date(), flutterData: nil), title:"Todo list")
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

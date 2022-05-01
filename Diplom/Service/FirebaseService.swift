//
//  FirebaseService.swift
//  Diplom
//
//  Created by KIRILL on 11.03.2022.
//

import FirebaseDatabase
import FirebaseStorage
import UIKit

final class FirebaseService: NSObject {

    enum Errors: Error {
        case data
        case error
    }
    
    private enum Keys: String {
        case images = "Изображения"
        case description = "Описание"
    }
    
    static func request(with value: String, complition: @escaping (Result<(description: String?, images: [String]?), Errors>) -> Void) {
        let ref = Database.database().reference()
//    
//        ref.child(value).setValue(["Изображения": ["SaintIsaacsCathedral1.jpg", "SaintIsaacsCathedral2.jpg", "SaintIsaacsCathedral3.jpg", "SaintIsaacsCathedral4.jpg", "SaintIsaacsCathedral5.jpg", "SaintIsaacsCathedral6.jpg", "SaintIsaacsCathedral7.jpg", "SaintIsaacsCathedral8.jpg", "SaintIsaacsCathedral9.jpg", "SaintIsaacsCathedral10.jpg", "SaintIsaacsCathedral11.jpg", "SaintIsaacsCathedral12.jpg", "SaintIsaacsCathedral13.jpg", "SaintIsaacsCathedral14.jpg"],
//                                   "Описание": "Исаакиевский собор — крупнейший на сегодняшний день православный храма Санкт-Петербурга и одно из высочайших купольных сооружений в мире. Его история началась в 1710 г., когда была построена деревянная церковь в честь Исаакия Далматского — византийского святого, на день памяти которого приходится день рождения Петра Великого. В ней в 1712 г. Петр обвенчался с Екатериной Алексеевной, своей второй супругой. Позже деревянную церковь заменили каменной. Третий храм был возведен во второй половине 18 в., однако сразу по окончании работ его объявили несоответствующим парадной застройке центра города. Император Александр I объявил конкурс на лучший проект по его перестройке. Через 9 лет получил одобрение проект молодого французского архитектора Огюста Монферрана, и началась работа. Сооружение собора длилось 40 лет и потребовало приложить огромное количество усилий. Однако результат превзошел все ожидания. Монументальность собора подчеркнута его квадратным построением. При строительстве было использовано 43 породы минералов. Цоколь облицован гранитом, а стены — серыми мраморными блоками толщиной около 40-50 см. С четырех сторон Исаакиевский собор обрамляют могучие восьмиколонные портики, украшенные статуями и барельефами. Над громадой собора высится грандиозных размеров золоченый купол на барабане, окруженном гранитными колоннами. Сам купол сделан из металла, а на его позолоту ушло около 100 кг червонного золота. Исаакиевский собор иногда называют музеем цветного камня. Внутренние стены облицованы белым мрамором с отделочным панно из зеленого и желтого мрамора, яшмы и порфира. Главный купол изнутри расписывал Карл Брюллов, также над внутренним убранство храма работали Василий Шебуев, Федора Бруни, Иван Витали и многие другие известные художники и скульпторы. Высота собора 101,5 м, в храме могут одновременно находиться 12 000 человек. Однако сам архитектор Монферран считал, что собор рассчитан на 7000 человек, учитывая пышные юбки дам, каждой из которых нужно не менее 1 кв. м. пространства. После революции храм был разорен, из него вынесли около 45 кг золота и более 2 т серебра. В 1928 г. службы были прекращены, и здесь открылся один из первых антирелигиозных соборов в стране. В годы Великой Отечественной войны подвалы храма служили хранилищем для произведений искусства, которые везли сюда со всех дворцов и музеев. Для маскировки купол перекрасили в серый цвет, но избежать бомбежек все же не удалось — по сей день на стенах и колоннах храма видны следы артобстрела. По самому куполу не стреляли, согласно легенде, немцы использовали его как ориентир на местности. Музейный статус был присвоен храму в 1948 г., а церковные службы по воскресениям и праздникам возобновлены в 1990 г., и эта традиция жива по сей день. Кроме того, в соборе регулярно проходят концерты, экскурсии и другие мероприятия"
//                                  ])
        
        ref.child(value).getData { error, snapshot in
            if error != nil {
                complition(.failure(.error))
                return
            }
            
            let pair = Self.parse(with: snapshot)
            complition(.success(pair))
        }
    }
    
    private static func parse(with snapshot: DataSnapshot) -> (description: String?, images: [String]?) {
        let value = snapshot.value as? NSDictionary
        let images = snapshot.childSnapshot(forPath: Keys.images.rawValue).value as? [String] ?? []
        let description = value?[Keys.description.rawValue] as? String ?? ""
        
        return (description: description, images: images)
    }
    
    static func requestImage(with value: String, complition: @escaping (Result<Data, Errors>) -> Void) {
        let storage = Storage.storage().reference()
        storage.child(value).getData(maxSize: 1 * 1024 * 1024) { snapshot, error in
            if error != nil {
                complition(.failure(.error))
                return
            }
            
            guard let data = snapshot else {
                complition(.failure(.data))
                return
            }
            
            complition(.success(data))
        }
    }
}

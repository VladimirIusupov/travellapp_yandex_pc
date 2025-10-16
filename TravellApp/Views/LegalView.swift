import SwiftUI

struct LegalView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("Оферта на оказание образовательных услуг дополнительного образования Яндекс.Практикум для физических лиц")
                    .font(.title3.weight(.bold))

                Text("""
Данный документ является действующим, если расположен по адресу:
""")

                Link("https://yandex.ru/legal/practicum_offer", destination: URL(string: "https://yandex.ru/legal/practicum_offer")!)
                    .font(.body)

                Text("Российская Федерация, город Москва")

                Text("1. ТЕРМИНЫ").font(.headline)

                Text("""
Понятия, используемые в Оферте, означают следующее:

Авторизованные адреса — адреса электронной почты каждой Стороны. Авторизованным адресом Исполнителя является адрес электронной почты, указанный в разделе 11 Оферты. Авторизованным адресом Студента является адрес электронной почты, указанный Студентом в Личном кабинете.

Вводный курс — начальный Курс обучения по представленным на Сервисе Программам обучения в рамках выбранной Студентом Профессии или Курса, рассчитанный на определенное количество часов самостоятельного ...
""")
                .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Пользовательское соглашение")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview { NavigationStack { LegalView() } }

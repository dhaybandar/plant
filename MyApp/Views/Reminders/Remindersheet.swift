import SwiftUI

struct ReminderSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: PlantStore

    private let existing: Plant?
    private let onSave: () -> Void

    @State private var name: String
    @State private var room: Room
    @State private var light: Light
    @State private var days: WateringDays
    @State private var water: WaterAmount
    @FocusState private var nameFocused: Bool

    init(plant: Plant?, onSave: @escaping () -> Void = {}) {//هويضمن تحميل البيانات الصحيحه في حقول الادخال سواء لتعديل نبته او لتجهيز الحقول لنبته جديده
        existing = plant
        self.onSave = onSave
        _name = State(initialValue: plant?.name ?? "")
        _room = State(initialValue: plant?.room ?? .bedroom)
        _light = State(initialValue: plant?.light ?? .fullSun)
        _days = State(initialValue: plant?.wateringDays ?? .everyDay)
        _water = State(initialValue: plant?.water ?? .a)
    }//بدونه لن تتمكن المتغيرات المراقبه من تلقي القيم الممرره بدقه خاصه وان النبات قد يكون نل في حاله الاضافه الجديده باختصار هو الجسر الي يربط بين البيانات الخارجيه وحاله الشاشه الخارجيه

    var body: some View {
        ZStack {
            Theme.sheet.ignoresSafeArea()

            VStack(spacing: 20) {
                navigationBar

                HStack {
                    Text("Plant Name")
                        .font(.subheadline)
                        .foregroundStyle(Theme.primaryText)
                    TextField("Pothos", text: $name)
                        .font(.subheadline)
                        .tint(Theme.accent)
                        .focused($nameFocused)
                        .submitLabel(.done)
                } .background(.ultraThinMaterial)
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(Theme.field, in: RoundedRectangle(cornerRadius: 12))

                VStack(spacing: 0) {
                    PickerRow(icon: "location", title: "Room", selection: $room)
                    Divider().overlay(Theme.separator).padding(.leading, 14)
                    PickerRow(icon: "sun.max", title: "Light", selection: $light)
                }
                .background(Theme.field, in: RoundedRectangle(cornerRadius: 12))

                VStack(spacing: 0) {
                    PickerRow(icon: "drop", title: "Watering Days", selection: $days)
                    Divider().overlay(Theme.separator).padding(.leading, 14)
                    PickerRow(icon: "drop", title: "Water", selection: $water)
                }
                .background(Theme.field, in: RoundedRectangle(cornerRadius: 12))

                if let existing {
                    Button {
                        store.delete(existing)
                        dismiss()//اذا النبته موجوده يطله زر الحذف
                    } label: {
                        Text("Delete Reminder")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.field, in: RoundedRectangle(cornerRadius: 12))
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .presentationDragIndicator(.visible)
        .onAppear {
            if existing == nil {
                nameFocused = true
            }//يعمل عند ظهور الشاشه فهو يتحقق مما اذا كنت تضيفين نبته جديد اذا ترو يضبط المتغير  نيم فوكسد على ترو لجعل الموشر داحل حقل الاسم تلقايا مما يسهل الكتابه فور
        }
    }

    private var navigationBar: some View {
        ZStack {
            Text("Set Reminder")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.primaryText)

            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Theme.primaryText)
                        .frame(width: 32, height: 32)
                        .background(Theme.separator.opacity(0.45), in: Circle())
                }
                Spacer()
                Button(action: save) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                        .background(Theme.button, in: Circle())
                }
            }
        }
    }

    private func save() {//فانكشن تقوم بمعالجه الاسم المدخل عن طريق ازاله المسافات الزايده او بمعنى ثاني ماتخلي اليوز يحط الاسم مسافات عشان تكون البيانات صحيحه
        let trimmedName = name.trimmingCharacters(in: .whitespaces)//
        let finalName = trimmedName.isEmpty ? "Planto" : trimmedName//اذا كان فارغ تضع اسم افتراضي

        if var plant = existing {
            plant.name = finalName
            plant.room = room
            plant.light = light
            plant.wateringDays = days
            plant.water = water
            store.update(plant)//يتحقق اذا النبته موجوده لتحديث بياناتها بعدين تستدعي ستور ابديت لحفظ التعديلات
        } else {
            store.add(
                Plant(
                    name: finalName,
                    room: room,
                    light: light,
                    wateringDays: days,
                    water: water//او تنشى نبته جديده وتضيفها
                )
            )
        }

        dismiss()
        onSave()
    }
}

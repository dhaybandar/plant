import SwiftUI

struct PlantListView: View {
    @EnvironmentObject private var store: PlantStore
    @State private var showAdd = false
    @State private var plantToEdit: Plant?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                Header()

                if store.plants.isEmpty {
                    Spacer()
                    Text("No reminders set yet..")//اذا فارغه رح يعرض لي هذا الرساله
                        .font(.caption)//
                        .foregroundStyle(Theme.secondaryText)
                    Spacer()
                } else if store.allDone {
                    AllDoneView()//اذا تم ري النباتات كلها رح يعرض لي اللي موجود في
                } else {
                    VStack(spacing: 10) {
                        Text(store.doneCount == 0
                             ? "Your plants are waiting for a sip 💦"
                             : "\(store.doneCount) of your plants feel loved today ✨")
                            .font(.caption)
                            .foregroundStyle(Theme.primaryText)
                            .padding(.top, 16)
                            .animation(.none, value: store.doneCount)
                        PlantProgressBar(progress: store.progress)
                            .padding(.horizontal, 20)
                    }//اذا لم تكتمل النهام يوضح عدد النباتات التي تم ريها مقارنه بالمجموع ويعرض شريط التقدم وليست النباتات لتتبعها
                    .padding(.bottom, 8)

                    List {
                        ForEach(store.plants) { plant in
                            PlantRow(
                                plant: plant,
                                onToggle: {
                                    withAnimation(.easeInOut) {
                                        store.toggle(plant)
                                    }
                                }
                            )
                            .contentShape(Rectangle())
                            .onTapGesture { plantToEdit = plant }//تستخدم لاكتشاف النقر على النبته وعند حدوث ذلك تقوم بتعيين النبته المحدده الى المتغير plattoedit لفتح شاشه التعديل الخاصه بها
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(Theme.separator)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        store.delete(plant)
                                    }//يحدد التفاعل مع عناصر الليست حيث يتيح النقر لتعديل النبته والسحب للحذف
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }

            Button {
                showAdd = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
            }
            .glassEffect(.regular.tint(Theme.button).interactive(), in: Circle())
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .animation(.easeInOut, value: store.allDone)//لضمان سلاسهالانتقال عند تغير حاله اكتمال المهمام ليكون التحديث مرن وغير مفاجئ
        .sheet(isPresented: $showAdd) {
            ReminderSheet(plant: nil)//يتحكم في عرض الشيت ريمندر
        }
        .sheet(item: $plantToEdit) { plant in
            ReminderSheet(plant: plant)
        }//عندما تسند قيمه للمتغير بلانت تو ادت يفتح النظام ريميندر شيت ويمرر له بيانات النبته المحدده لتعديلها
    }
}

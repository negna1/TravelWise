//
//  LikeDislikeList.View.swift
//  TravelWIse
//
//  Created by Nato Egnatashvili on 23.09.22.
//
import SwiftUI
import ComposableArchitecture

struct LikeDislikeListView: View {
    let store: Store<LikeDislikeList.State, LikeDislikeList.Action>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ForEach(viewStore.state.list, id: \.self) { dest in
                Text(dest.title ?? "")
            }
        }
    }
}

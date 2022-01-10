//
//  SlideToUnlock.swift
//  Progressive
//
//  Created by Dominik Butz on 6/11/2021.
//  Copyright © 2021 Duoyun. All rights reserved.
//

import SwiftUI

public struct TriggerSlider<SliderView: View, BackgroundView: View, TextView: View>: View {
    
    var sliderView: SliderView
    var textView: TextView
    var backgroundView: BackgroundView
    
    public var didSlideToEnd: ()->Void
    
    var settings: TriggerSliderSettings

    @Binding var offsetX: CGFloat
    
    /**
    Initializer
     - Parameter sliderView:  The slider view
     - Parameter textView: Text view that is located between the slider view and the background. Does not have to be a Text, can be any other view.
     - Parameter backgroundView: The background view of the slider.
     - Parameter offsetX: The horizontal offset of the slider view.  Should be set to 0 as initial value.  Value changes as the slider is moved by the user's drag gesture.
     - Parameter didSlideToEnd: Closure is called when the slider is moved to the end position. In your code, determine what should happend in that case.
    */
    public init(@ViewBuilder sliderView: ()->SliderView, textView: ()->TextView, backgroundView: ()->BackgroundView, offsetX: Binding<CGFloat>, didSlideToEnd: @escaping ()->Void, settings: TriggerSliderSettings = TriggerSliderSettings()) {
        self.sliderView = sliderView()
        self.backgroundView = backgroundView()
        self.textView = textView()
        self._offsetX = offsetX
        self.didSlideToEnd = didSlideToEnd
        self.settings = settings
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                
                backgroundView
                    .frame(height: settings.sliderViewHeight + settings.sliderViewVPadding)
                
                textView
                    .opacity(self.textLabelOpacity(totalWidth: proxy.size.width))
                
                HStack {
                    
                    if settings.slideDirection == .left {
                        Spacer()
                    }
                    
                    self.sliderView
                        .frame(width: settings.sliderViewWidth, height: settings.sliderViewHeight)
                        .padding(.horizontal, settings.sliderViewHPadding)
                        .padding(.vertical, settings.sliderViewVPadding)
                        .offset(x: self.offsetX, y: 0)
                        .gesture(DragGesture(coordinateSpace: .local).onChanged({ value in
                            
                            self.dragOnChanged(value: value, totalWidth: proxy.size.width)
                            
                    }).onEnded({ value in
                        self.dragOnEnded(value: value, totalWidth: proxy.size.width)
               
                    }))
                    
                    if settings.slideDirection == .right {
                        Spacer()
                    }
                }
  
            }
        }
    }
    
    func dragOnChanged(value: DragGesture.Value, totalWidth: CGFloat) {
        
        let rightSlidingChangeCondition = settings.slideDirection == .right && value.translation.width > 0 && offsetX <= totalWidth  - settings.sliderViewWidth - settings.sliderViewHPadding * 2
        let leftSlidingChangeCondition = settings.slideDirection == .left && value.translation.width < 0 && offsetX >= -totalWidth  + settings.sliderViewWidth + settings.sliderViewHPadding * 2
        
        if rightSlidingChangeCondition || leftSlidingChangeCondition  {
                self.offsetX = value.translation.width
        }
    }
    
    func dragOnEnded(value: DragGesture.Value, totalWidth: CGFloat) {
        
        let resetConditionSlideRight = self.settings.slideDirection == .right && self.offsetX < totalWidth - settings.sliderViewWidth - settings.sliderViewHPadding * 2
        
        let resetConditionSlideLeft = self.settings.slideDirection == .left && self.offsetX > -(totalWidth - settings.sliderViewWidth - settings.sliderViewHPadding * 2)
        
        if resetConditionSlideRight || resetConditionSlideLeft {
            withAnimation {
                self.offsetX = 0
            }
        } else {
            self.didSlideToEnd()
        }
    }
    
    func textLabelOpacity(totalWidth: CGFloat)->CGFloat {
        let halfTotalWidth =  totalWidth / 2
        return (halfTotalWidth - abs(self.offsetX)) / halfTotalWidth
    }
}

public struct TriggerSliderSettings {

    /**
    Initializer
     - Parameter sliderViewHeight:  height of the slider. Default is 40
     - Parameter sliderViewWidth: width of the slider. Default is 40.
     - Parameter sliderViewHPadding: horizontal padding of the sliderView relative to the background edges. Default 0.
     - Parameter sliderViewVPadding: vertical padding of the sliderView relative to the background edges. Default 0.
     - Parameter slideDirection: slide direction of the slider (left or right). Default:  right.
    */
    public init(sliderViewHeight: CGFloat = 40, sliderViewWidth: CGFloat = 40, sliderViewHPadding: CGFloat = 0, sliderViewVPadding:CGFloat = 0, slideDirection: SlideDirection = .right) {
        self.sliderViewWidth = sliderViewWidth
        self.sliderViewHeight = sliderViewHeight
        self.sliderViewHPadding = sliderViewHPadding
        self.sliderViewVPadding = sliderViewVPadding
        self.slideDirection = slideDirection
    }

    var sliderViewHeight: CGFloat
    var sliderViewWidth: CGFloat
    var sliderViewHPadding: CGFloat
    var sliderViewVPadding: CGFloat
    var slideDirection: SlideDirection

}

public enum SlideDirection {
    case left, right
}

// this file is generated via Daslang automatic binder
// all user modifications will be lost after this file is re-generated

template <> struct cast_arg<ImPlotPoint> {
	static __forceinline const ImPlotPoint & to ( Context & ctx, SimNode * node ) {
		vec4f res = node->eval(ctx);
		return * cast<ImPlotPoint *>::to(res);
	}
};
template <> struct cast_arg<ImPlotRange> {
	static __forceinline const ImPlotRange & to ( Context & ctx, SimNode * node ) {
		vec4f res = node->eval(ctx);
		return * cast<ImPlotRange *>::to(res);
	}
};
template <> struct cast_arg<ImPlotRect> {
	static __forceinline const ImPlotRect & to ( Context & ctx, SimNode * node ) {
		vec4f res = node->eval(ctx);
		return * cast<ImPlotRect *>::to(res);
	}
};
template <> struct cast_arg<ImPlotStyle> {
	static __forceinline const ImPlotStyle & to ( Context & ctx, SimNode * node ) {
		vec4f res = node->eval(ctx);
		return * cast<ImPlotStyle *>::to(res);
	}
};
template <> struct cast_arg<ImPlotInputMap> {
	static __forceinline const ImPlotInputMap & to ( Context & ctx, SimNode * node ) {
		vec4f res = node->eval(ctx);
		return * cast<ImPlotInputMap *>::to(res);
	}
};
